class Elevator
  def initialize
    @current_floor     = 1
    @requested_floors  = [] # NOTE: Should we distinguish between requests inside and outside the elevator?

    @direction = :up
  end

  def add_destination(destination)
    return if @current_floor == destination

    @requested_floors << destination
    @requested_floors.sort!
  end

  def tick
    if @requested_floors.empty?
      puts "Elevator is waiting for requests"
    elsif @requested_floors.include?(@current_floor)
      @requested_floors.delete(@current_floor)

      puts "Elevator makes a stop at floor #{@current_floor}"
    elsif @direction == :up
      if @requested_floors.find { |e| e > @current_floor }
        @current_floor += 1
        puts "Elevator moves up to floor #{@current_floor}"
      else
        puts "Elevator is now going down"
        @direction = :down
      end
    elsif @direction == :down
     if @requested_floors.find { |e| e < @current_floor }
        @current_floor -= 1
        puts "Elevator moves down to floor #{@current_floor}"
     else
        puts "Elevator is now going up"
        @direction = :up
      end
    else
      puts "Whoops! Elevator is probably on fire. Bad programmer!"
    end
  end
end

e = Elevator.new


loop do
  if rand(1..5) == 1
    destination = rand(1..20)
    puts "Request made to visit floor #{destination}"
    e.add_destination(destination)
  end

  e.tick

  sleep 0.5
end



