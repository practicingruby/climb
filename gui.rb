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
  def self.run(building)
    innerPane = JPanel.new(BorderLayout.new)
    innerPane.setPreferredSize(Dimension.new(1000,800))
    innerPane.setBorder(EmptyBorder.new(20, 20, 20, 20))

    tab = javax.swing.table.DefaultTableModel.new
    tab.add_column("floor")
    tab.add_column("Elevator #1")
    tab.add_column("Elevator #2")
    tab.add_column("Elevator #3")
    tab.add_column("waiting")
    tab.add_column("visiting")

    tab.add_row(["Floor", "Elevator #1", "Elevator #2", "Elevator #3", "Waiting", "Visiting"].to_java)
    tab.add_row(["5", "", "", "", "", ""].to_java)
    tab.add_row(["4", "", "", "", "", ""].to_java)
    tab.add_row(["3", "", "", "", "", ""].to_java)
    tab.add_row(["2", "", "", "", "", ""].to_java)
    tab.add_row(["1", "[               ]", "[               ]", "[               ]", "", ""].to_java)

    table = JTable.new(tab)
    table.get_column("floor").setMaxWidth(50)
    table.get_column("Elevator #1").setMaxWidth(150)
    table.get_column("Elevator #1").setMinWidth(150)
    table.get_column("Elevator #2").setMaxWidth(150)
    table.get_column("Elevator #2").setMinWidth(150)
    table.get_column("Elevator #3").setMaxWidth(150)
    table.get_column("Elevator #3").setMinWidth(150)
    table.get_column("visiting").setMaxWidth(150)
    table.setFont(Font.new("Monospaced", Font::PLAIN, 12))


    col = table.getColumnModel().getColumn(1);
    col.setCellRenderer(CustomRenderer.new(Color.red));

    col = table.getColumnModel().getColumn(2);
    col.setCellRenderer(CustomRenderer.new(Color.red.darker));

    col = table.getColumnModel().getColumn(3);
    col.setCellRenderer(CustomRenderer.new(Color.red.darker.darker));

    col = table.getColumnModel().getColumn(4);
    col.setCellRenderer(CustomRenderer.new(Color.blue));

    col = table.getColumnModel.getColumn(5);
    col.setCellRenderer(CustomRenderer.new(Color.darkGray));

    innerPane.add(table, BorderLayout::CENTER)


    frame = JFrame.new
    frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    frame.add(innerPane)
    frame.pack
    frame.show

    building.redraw(table)

    [ElevatorUI.new(table, "Elevator #1", 5, building),
     ElevatorUI.new(table, "Elevator #2", 5, building),
     ElevatorUI.new(table, "Elevator #3", 5, building)]
  end

  class PeopleCounter
    def self.person_glyph(count)
      (["웃"]*count).join(" ") 
    end
    
    def self.abridged_person_glyph(count)
      "웃 x #{count}"
    end
  end

  class Building
    def initialize
      @lobby_occupants = Hash.new(0)
      @visitors        = Hash.new(0)
    end
    
    attr_reader :lobby_occupants, :visitors

    def passenger_starts_visiting(n)
      @visitors[n] += 1
    end
    
    def visitor_enters_lobby(n)
      @visitors[n] -= 1
      @lobby_occupants[n] += 1
    end

    def visitor_leaves_building
      @visitors[1] -= 1
    end

    def redraw(table)
      lobby_column    = table.getColumn("waiting").model_index
      visiting_column = table.getColumn("visiting").model_index

      (1..5).each do |n|
        row = 6 - n
        
        table.setValueAt(PeopleCounter.person_glyph(@lobby_occupants[n]), row, lobby_column)
        table.setValueAt(PeopleCounter.abridged_person_glyph(@visitors[n]), row, visiting_column)
      end
    end
  end

  def initialize(table, elevator_name, start_row, building)
    @table           = table
    @row             = start_row
    @elevator_name   = elevator_name
    @passengers      = 0
    @building        = building
  end

  attr_reader :lobby_occupants, :visitors, :building, :table, :passengers
  
  def floor
    6 - @row 
  end

  def elevator_column
    @table.get_column(@elevator_name).model_index
  end

  def empty?
    @passengers.zero?
  end


  def load_passenger
    @building.lobby_occupants[floor] -= 1
    @passengers += 1

    redraw
  end

  def unload_passenger
    @passengers -= 1
    @building.passenger_starts_visiting(floor)
    
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
    end
    
    @building.redraw(@table)
  end

  def passenger_person_glyph
    "[#{PeopleCounter.person_glyph(@passengers).ljust(15)}]"
  end
end