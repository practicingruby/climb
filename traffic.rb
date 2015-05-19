require_relative "passenger"

class Traffic
  def initialize
    @passengers = 20.times.map {
      start = rand(1..5)
      finish = rand(1..5)

      redo if start == finish
      
      Passenger.new(start, finish)
    }
  end

  def add_passenger(start, finish)
    passenger = Passenger.new(start, finish)
    @passengers << passenger

    passenger
  end

  def all_passengers
    @passengers
  end

  def entering_passengers(elevator)
    passengers_in_lobbies.select { |e| e.origin == elevator.location }
  end

  def exiting_passengers(elevator)
    passengers_in_elevator(elevator).select { |e| e.destination == elevator.location }
  end

  def passengers_in_elevator(elevator)
    @passengers.select { |e| e.riding == elevator} 
  end
  
  def passengers_in_lobbies
    @passengers.reject { |e| e.riding } 
  end

  def transfer!(elevator)
    counts = { :loaded   => entering_passengers(elevator).count, 
               :unloaded => exiting_passengers(elevator).count }

    @passengers -= exiting_passengers(elevator)

    entering_passengers(elevator).each { |e| e.riding = elevator }

    return counts
  end
end