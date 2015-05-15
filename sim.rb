require_relative "gui"
require_relative "elevator"
require_relative "clock"
require_relative "passenger"
require_relative "traffic"

ui = ElevatorUI.run
elevator = Elevator.new

traffic = Traffic.new(elevator)

i = rand(4..5)

puts "Call requested at #{i}"

traffic.passengers_in_lobbies.each do |e|
  ui.passenger_starts_visiting(e.origin)
  ui.visitor_enters_lobby(e.origin)
end

Clock.watch { |t| elevator.tick(t) }

Clock.watch { |t| ui.move_to(elevator.location) if ui.floor != elevator.location }

Clock.watch do |t|
  deltas = traffic.transfer!

  deltas[:unloaded].times do
    ui.unload_passenger
  end
  
  deltas[:loaded].times do
    ui.load_passenger
  end
end

Clock.start

until traffic.all_passengers.empty?
  if elevator.location == 5 && elevator.direction == :up
    Clock.tick { elevator.stop }
    elevator.going_down
  
  elsif elevator.location == 1 && elevator.direction == :down
    Clock.tick { elevator.stop }
    elevator.going_up
  end
  
  elevator.start

  Clock.tick
end

puts "Simulation complete!"