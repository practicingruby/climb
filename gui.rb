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
tab.add_row(["1", "[]", "", ""].to_java)


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

  def move_down
    @row += 1
    redraw
  end

  def move_up
    @row -= 1
    redraw
  end

  # NOTE: If this gets slow, redraw only when a cell needs to change,
  # immediately when that individual change is made. (i.e. use events)
  def redraw
    (1..5).each do |n|
      row = 6 - n
      
      if floor == n
        @table.setValueAt(passenger_snowmen, row, elevator_column)
      else
        @table.setValueAt("", row, elevator_column)
      end
      
      lobby_column = @table.getColumn("waiting").model_index
      visiting_column = @table.getColumn("visiting").model_index

      @table.setValueAt(snowmen(@lobby_occupants[n]), row, lobby_column)
      @table.setValueAt(abridged_snowmen(@visitors[n]), row, visiting_column)
    end
  end

  def passenger_snowmen
    "[ #{snowmen(@passengers)}]"
  end

  def snowmen(count)
    (["☃"]*count).join(" ") 
  end
  
  def abridged_snowmen(count)
    "☃ x #{count}"
  end
end

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

elevator = ElevatorUI.new(table, 5)

50.times do
  elevator.passenger_starts_visiting(1)
end

loop do
  case rand(1..12)
  when 1
    if elevator.lobby_occupants[elevator.floor] > 0
      elevator.load_passenger
    end
  when 2
    elevator.unload_passenger unless elevator.empty?
  when (3..6)
    elevator.move_up unless elevator.floor == 5
  when (7..11)
    elevator.move_down unless elevator.floor == 1
  when 12
    random_floor = rand(1..5)
    if elevator.visitors[random_floor] > 0
      elevator.visitor_enters_lobby(random_floor)
    end
  end
  
  sleep 0.25
end