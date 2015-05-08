class ElevatorController
  def initialize(elevator)
    @elevator          = elevator
    @requested_floors  = [] # NOTE: Should we distinguish between requests inside and outside the elevator?

    @direction = :up
  end

  def add_destination(destination)
    return if @elevator.floor == destination

    @requested_floors << destination
    @requested_floors.sort!
  end

  def tick
    if @requested_floors.empty?
      puts "Elevator is waiting for requests"
    elsif @requested_floors.include?(@elevator.floor)
      @requested_floors.delete(@elevator.floor)
      puts "Elevator makes a stop at floor #{@elevator.floor}"

      @elevator.unload_passenger until @elevator.empty? 
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