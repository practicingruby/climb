require_relative "passenger"

class Traffic
  def initialize(elevator)
    @elevator = elevator

    @passengers = 5.times.map {
      start = rand(1..5)
      finish = rand(1..5)

      redo if start == finish
      
      puts "P: #{start} #{finish}"
      Passenger.new(start, finish)
    }
  end
  
  def all_passengers
    @passengers
  end

  def entering_passengers
    passengers_in_lobbies.select { |e| e.origin == @elevator.location }
  end

  def exiting_passengers
    passengers_in_elevator.select { |e| e.destination == @elevator.location }
  end

  def passengers_in_elevator
    @passengers.select { |e| e.riding } 
  end
  
  def passengers_in_lobbies
    @passengers.reject { |e| e.riding } 
  end

  def transfer!
    counts = { :loaded   => entering_passengers.count, 
               :unloaded => exiting_passengers.count }

    @passengers -= exiting_passengers

    entering_passengers.each { |e| e.riding = true }

    return counts
  end
end