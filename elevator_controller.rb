class ElevatorController
  # TODO: Generalize to handle multiple elevators
  # IDEA: Consider integrating an event based solution here by
  # having elevator publish "Elevator is at FLOOR N, STATE=moving" events
  def initialize(elevator)
    @elevator = elevator
    @landing_calls = {}
    @car_calls     = [] 
  end

  def call(event, params)
    case event
    when :landing_call
      @landing_calls[params[:floor], params[:direction]] = true
    when :car_call
      @car_calls << params[:floor]
    when :elevator_stopped
      puts "Elevator is stopped, waiting for doors to open..."
    end
  end

  def stop_needed?
    @elevator.can_platform? &&
    (@car_calls.include?(@elevator.location) ||
     @landing_calls[@elevator.location, @elevator.direction])
  end

  def tick
    @elevator.stop if stop_needed?
  end
end