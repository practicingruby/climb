include Java

import javax.swing.JPanel
import java.awt.BorderLayout
import java.awt.Dimension
import javax.swing.border.EmptyBorder
import javax.swing.table.DefaultTableModel
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
tab.add_row(["1", "0", "5", "7"].to_java)
tab.add_row(["2", "0", "5", "7"].to_java)
tab.add_row(["3", "0", "5", "7"].to_java)
tab.add_row(["4", "0", "5", "7"].to_java)
tab.add_row(["5", "0", "5", "7"].to_java)
#innerPane.add(tab, BorderLayout::CENTER)

table = JTable.new(tab)
innerPane.add(table, BorderLayout::CENTER)

frame = JFrame.new
frame.add(innerPane)
frame.pack
frame.show

sleep 3
tab.setValueAt("Replacement!", 2, 1)
