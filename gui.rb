include Java

import javax.swing.JPanel
import java.awt.BorderLayout
import java.awt.Dimension
import java.awt.Color
import java.awt.Font
import javax.swing.border.EmptyBorder
import javax.swing.table.DefaultTableModel
import javax.swing.table.DefaultTableCellRenderer
import javax.swing.JTable
import javax.swing.JFrame

class CustomRenderer < DefaultTableCellRenderer
  def initialize(color)
    super()

    @color = color
  end 

  def getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column)
    c = super;
    setForeground(@color)
    return c;
  end
end

class ElevatorUI
  def self.run
    innerPane = JPanel.new(BorderLayout.new)
    innerPane.setPreferredSize(Dimension.new(800,800))
    innerPane.setBorder(EmptyBorder.new(20, 20, 20, 20))

    tab = javax.swing.table.DefaultTableModel.new
    tab.add_column("floor")
    tab.add_column("in elevator")
    tab.add_column("waiting")
    tab.add_column("visiting")

    tab.add_row(["Floor", "In elevator", "Waiting", "Visiting"].to_java)
    tab.add_row(["5", "", "", ""].to_java)
    tab.add_row(["4", "", "", ""].to_java)
    tab.add_row(["3", "", "", ""].to_java)
    tab.add_row(["2", "", "", ""].to_java)
    tab.add_row(["1", "[               ]", "", ""].to_java)

    table = JTable.new(tab)
    table.get_column("floor").setMaxWidth(50)
    table.get_column("in elevator").setMaxWidth(150)
    table.get_column("in elevator").setMinWidth(150)
    table.get_column("visiting").setMaxWidth(150)
    table.setFont(Font.new("Monospaced", Font::PLAIN, 12))


    col = table.getColumnModel().getColumn(1);
    col.setCellRenderer(CustomRenderer.new(Color.red));

    col = table.getColumnModel().getColumn(2);
    col.setCellRenderer(CustomRenderer.new(Color.blue));

    col = table.getColumnModel.getColumn(3);
    col.setCellRenderer(CustomRenderer.new(Color.darkGray));

    innerPane.add(table, BorderLayout::CENTER)


    frame = JFrame.new
    frame.add(innerPane)
    frame.pack
    frame.show

    ElevatorUI.new(table, 5)
  end

  def initialize(table, start_row)
    @table           = table
    @row             = start_row
    @passengers      = 0
    @lobby_occupants = Hash.new(0)
    @visitors        = Hash.new(0)
  end

  attr_reader :lobby_occupants, :visitors
  
  def floor
    6 - @row 
  end

  def elevator_column
    @table.get_column("in elevator").model_index
  end

  def empty?
    @passengers.zero?
  end

  def visitor_enters_lobby(n)
    @lobby_occupants[n] += 1
    @visitors[n] -= 1
    
    redraw
  end

  def passenger_starts_visiting(n)
    @visitors[n] += 1
    redraw
  end

  def load_passenger
    @lobby_occupants[floor] -= 1
    @passengers += 1

    redraw
  end

  def unload_passenger
    @passengers -= 1
    passenger_starts_visiting(floor)
    
    redraw
  end

  def move_to(floor)
    @row = 6 - floor
    redraw
  end

  # NOTE: If this gets slow, redraw only when a cell needs to change,
  # immediately when that individual change is made. (i.e. use events)
  def redraw
    (1..5).each do |n|
      row = 6 - n
      
      if floor == n
        @table.setValueAt(passenger_person_glyph, row, elevator_column)
      else
        @table.setValueAt("", row, elevator_column)
      end
      
      lobby_column = @table.getColumn("waiting").model_index
      visiting_column = @table.getColumn("visiting").model_index

      @table.setValueAt(person_glyph(@lobby_occupants[n]), row, lobby_column)
      @table.setValueAt(abridged_person_glyph(@visitors[n]), row, visiting_column)
    end
  end

  def passenger_person_glyph
    "[#{person_glyph(@passengers).ljust(15)}]"
  end

  def person_glyph(count)
    (["웃"]*count).join(" ") 
  end
  
  def abridged_person_glyph(count)
    "웃 x #{count}"
  end
end