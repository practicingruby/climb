
class Elevator

  attr_reader :motor

  def initialize
    @last_stop = 1 
  end

  def location
    if motor == :stopped
      @last_stop
    else
      @last_stop + distance_traveled
    end
  end

  def going_up
    @direction = :up
  end
  
  def going_down
    @direction = :down
  end

  def stop
    puts "Stopping elevator"
    @motor = :stopping
  end

  def start
    puts "Starting elevator"
    @motor = :starting
  end

  def open_doors
    @doors = :open
  end

  def close_doors
    @doors = :closed
  end

  def current_floor
    @floor
  end

  def tick(t)
    @last_tick = t

    case @motor
    when :starting
      @motor_start_time = t
      @motor = :started
    when :stopping
      # Only stop after traveling at least one floor
      return if distance_traveled.zero?

      @last_stop += distance_traveled
      @motor      = :stopped

      puts "The elevator has stopped moving"
    end
  end

  private

  # The first floor costs 4.5s of travel time, each additional floor costs 1.5s
  def distance_traveled
    return 0 unless @motor == :started || @motor == :stopping

    last_trip_duration = (@last_tick - @motor_start_time)
    return 0 unless last_trip_duration >= 4.5

    1 + ((last_trip_duration - 4.5) / 1.5).floor
  end
end


e = Elevator.new

t=0

5.times do
  e.start

  ticks = rand(20...150)



  ticks.times do |i|
    t += 0.1
    sleep 0.1
    puts "t=#{t}"
    
    e.tick(t)
    puts "Elevator is at #{e.location}"
  end

  e.stop

  until e.motor == :stopped
    t += 0.1
    sleep 0.1
    puts "t=#{t}"
    puts "Elevator is at #{e.location}"
    e.tick(t)
  end
    
  puts "Elevator is at #{e.location}"
end









