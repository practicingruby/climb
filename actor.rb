require "faker"

class Actor
  def initialize
    @starting_floor    = 1
    @destination_floor = rand(2..5)
    @status            = :waiting
    @name              = Faker::Name.first_name

    puts "#{@name} enters a call for an elevator going up"
  end

  attr_reader :starting_floor, :destination_floor, :status, :name

  def listen(event, params)
    case event
    when :doors_open
      case @status
      when :waiting
        if params[:floor] == @starting_floor
          puts "#{@name} boards elevator at #{@starting_floor}"
          puts "#{@name} requests to visit floor #{@destination_floor}"
          @status = :riding
        end
      when :riding
        if params[:floor] == @destination_floor
          puts "#{@name} exits elevator at #{@destination_floor}"
          @status = :visiting
        end
      end
    end
  end
end

actor = Actor.new

puts "#{actor.name} is #{actor.status}"
actor.listen(:doors_open, :floor => 1)
puts "#{actor.name} is #{actor.status}"
actor.listen(:doors_open, :floor => actor.destination_floor)
puts "#{actor.name} is #{actor.status}"
