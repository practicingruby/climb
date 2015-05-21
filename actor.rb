require "faker"

# FIXME: Instead of explicitly calling UI events, publish them to observers
# or a common feed.

class Actor
  def initialize
    @status            = :waiting
    @name              = Faker::Name.first_name
  end

  def arrive(building)
    puts "#{@name} arrives at the building"

    @starting_floor    = 1
    @destination_floor = rand(2..5)
    
    building.passenger_starts_visiting(@starting_floor)
    building.visitor_enters_lobby(@starting_floor)

    EventLog.publish(:landing_call, :direction => :up, :floor => @starting_floor)
  end

  def leave(building)
    @starting_floor    = @destination_floor
    @destination_floor = 1

    @status = :waiting
    building.visitor_enters_lobby(@starting_floor)

    EventLog.publish(:landing_call, :direction => :down, :floor => @starting_floor)

    puts "#{@name} wants to leave the building"
  end

  attr_reader :starting_floor, :destination_floor, :status, :name

  def call(event, params)
    case event
    when :doors_open
      case @status
      when :waiting
        if params[:floor] == @starting_floor && params[:ui].passengers < 3
          params[:ui].load_passenger
          puts "#{@name} boards elevator at #{@starting_floor}"
          puts "#{@name} requests to visit floor #{@destination_floor}"
          @status = :riding
          @ui     = params[:ui] # Gross!
        end
      when :riding
        if params[:floor] == @destination_floor && params[:ui] == @ui
          params[:ui].unload_passenger
          puts "#{@name} exits elevator at #{@destination_floor}"

          if params[:floor] == 1
            @status = :gone
            params[:ui].building.visitor_leaves_building
            puts "#{@name} has left the building!"
          else
            @status = :visiting
          end
          
          @ui = nil # Gross!
        end
      end
    end
  end
end