class Passenger
  def initialize(origin, destination)
    @origin      = origin
    @destination = destination
    @riding      = false
  end

  attr_reader :origin, :destination
  attr_accessor :riding
end