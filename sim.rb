require_relative "gui"
require_relative "elevator"
require_relative "clock"
require_relative "passenger"
require_relative "traffic"
require_relative "actor"
require_relative "event_log"

=begin
building  = ElevatorUI::Building.new
elevators = ElevatorUI.run(building).zip(3.times.map { Elevator.new })


actors = [Actor.new]

actors.each { |e| e.arrive(building) }
actors.each { |e| EventLog.subscribers << e }

EventLog.subscribe do |event, params|
  
end

# HACK: Should not need to do this.
building.redraw(elevators.first.first.table)

# HACK: Should not need to do this, either.
elevators.shuffle.each do |ui,model|
  EventLog.publish(:doors_open, :floor => model.location, :ui => ui)
end

Clock.watch do |t| 
  elevators.shuffle.each do |ui,model| 
    model.tick(t) 
    if ui.floor != model.location
      ui.move_to(model.location) 
      EventLog.publish(:doors_open, :floor => model.location, :ui => ui)
    end
  end
end


Clock.start

loop do
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

  actors.each do |actor|
    if actor.status == :visiting
      if rand < 0.01
        actor.leave(building)
      end
    end
  end

  if rand < ((30..45).include?(Clock.time) ? 0.2 : 0.01)
    new_actor = Actor.new
    EventLog.subscribe(new_actor)
    new_actor.arrive(building)

    actors << new_actor
  end

  Clock.tick
  
  print "#{Clock.time}..."
end
=end


=begin
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
=end