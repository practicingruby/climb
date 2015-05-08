require_relative "gui"
require_relative "model"

elevator = ElevatorUI.run
controller = ElevatorController.new(elevator)

50.times do
  elevator.passenger_starts_visiting(1)
end

loop do
  random_floor = rand(1..5)
  if elevator.visitors[random_floor] > 0
    elevator.visitor_enters_lobby(random_floor) 
    controller.add_destination(random_floor)
  end

  controller.tick

  sleep 0.5
end