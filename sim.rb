require_relative "gui"
require_relative "elevator"
require_relative "clock"
require_relative "passenger"
require_relative "traffic"

building  = ElevatorUI::Building.new
elevators = ElevatorUI.run(building).zip(3.times.map { Elevator.new })

traffic = Traffic.new

traffic.passengers_in_lobbies.each do |e|
  # FIXME: Should be able to trigger a redraw automatically on these events
  building.passenger_starts_visiting(e.origin)
  building.visitor_enters_lobby(e.origin)
end

Clock.watch { |t| elevators.each { |ui,model| model.tick(t) } }

Clock.watch do 
  elevators.each do |ui, model|
    ui.move_to(model.location) if ui.floor != model.location
  end
end

Clock.watch do
  elevators.shuffle.each do |ui, model|
    deltas = traffic.transfer!(model)

    deltas[:unloaded].times do
      ui.unload_passenger
    end
    
    deltas[:loaded].times do
      ui.load_passenger
    end
  end
end

Clock.start

until traffic.all_passengers.empty?
  elevators.each do |ui, model|
    if model.location == 5 && model.direction == :up
      Clock.tick { model.stop }
      model.going_down
    
    elsif model.location == 1 && model.direction == :down
      Clock.tick { model.stop }
      model.going_up
    end
    
    model.start
  end

  Clock.tick
end

puts "Simulation complete!"