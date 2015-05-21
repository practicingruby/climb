class ElevatorController
  # TODO: Generalize to handle multiple elevators
  # IDEA: Consider integrating an event based solution here by
  # having elevator publish "Elevator is at FLOOR N, STATE=moving" events
  # FIXME: Should not take UI as a param
  def initialize(elevator, ui)
    @elevator = elevator
    @ui       = ui
    @landing_calls = {}
    @car_calls     = [] 
  end

  def call(event, params)
    case event
    when :landing_call
      if (@elevator.motor == :stopped && @elevator.location == params[:floor] && @elevator.direction == params[:direction])
        puts "[#{Clock.time}] open the doors!"
        EventLog.publish(:doors_open, :floor => @elevator.location, :ui => @ui)
        
        # TODO: Use hash w. elevator ID
        Clock.start_timer(:doors_opened)
      else 
        puts "[#{Clock.time}] A landing call is made for #{params[:floor]}"
        @landing_calls[[params[:floor], params[:direction]]] = true
      end
    when :car_call
      @car_calls << params[:floor]
    when :elevator_stopped
      puts "[#{Clock.time}] open the doors!"
      EventLog.publish(:doors_open, :floor => @elevator.location, :ui => @ui)
        
      Clock.start_timer(:doors_opened)
    when :doors_closed
      # restart elevator if there are more requests to fill
    end
  end

  def stop_needed?
    @elevator.can_platform? &&
    (@car_calls.include?(@elevator.location) ||
     @landing_calls[[@elevator.location, @elevator.direction]])
  end

  def tick
    @elevator.stop if stop_needed?

    Clock.alarm(:doors_opened, 5) do
      puts "[#{Clock.time}] Doors closing!"
      @car_calls.delete(@elevator.location)
      @landing_calls.delete([@elevator.location, @elevator.direction])

      EventLog.publish(:doors_closed, :floor => @elevator.location, :ui => @ui)

      @elevator.start if @car_calls.any? || @landing_calls.any?
    end
  end
end