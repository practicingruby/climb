class ElevatorController
  def initialize(elevator)
    @elevator         = elevator
    @landing_calls    = []
    @car_calls        = []

    @direction = :up
  end

  def landing_call(destination)
    return if @elevator.floor == destination

    @landing_calls << destination
    @landing_calls.sort!
  end

  def car_call(destination)
    return if @elevator.floor == destination

    @car_calls << destination
    @car_calls.sort!
  end

  def scheduled_stops
    (@landing_calls + @car_calls).uniq
  end

  def tick
    if scheduled_stops.empty?
      puts "Elevator is waiting for requests"
    elsif scheduled_stops.include?(@elevator.floor)
      @requested_floors.delete(@elevator.floor)
      puts "Elevator makes a stop at floor #{@elevator.floor}"

      @elevator.unload_passenger
    elsif @direction == :up
      if @requested_floors.find { |e| e > @elevator.floor }
        @elevator.move_up
        puts "Elevator moves up to floor #{@elevator.floor}"
      else
        puts "Elevator is now going down"
        @direction = :down
      end
    elsif @direction == :down
     if @requested_floors.find { |e| e < @elevator.floor }
        @elevator.move_down
        puts "Elevator moves down to floor #{@elevator.floor}"
     else
        puts "Elevator is now going up"
        @direction = :up
      end
    else
      puts "Whoops! Elevator is probably on fire. Bad programmer!"
    end

    occupants = @elevator.lobby_occupants[@elevator.floor]
    if occupants > 0
      occupants.times { @elevator.load_passenger }
      add_destination(p rand(1..5))
    end
  end
end