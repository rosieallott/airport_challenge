require './lib/plane'
require './lib/weather'

class Airport
  CAPACITY = 10

  def initialize(capacity = CAPACITY)
    @planes = []
    @capacity = capacity
  end

  def land(plane)
    fail "Airport full" if full?
    fail "This plane has already landed" if @planes.include?(plane)
    fail "too stormy to land" if weather_check == "stormy"
    @planes << plane
    plane.plane_landed
  end

  def take_off(plane)
    fail "no planes at the airport" if @planes.empty?
    msg = "This plane has already taken off from this airport"
    fail msg if !@planes.include?(plane)
    fail "too stormy to take off" if weather_check == "stormy"
    @planes.delete(plane)
    plane.plane_taking_off
  end

private

  def weather_check
    current_weather = Weather.new
    "stormy" if current_weather.stormy?
  end

  def full?
    @planes.count >= @capacity
  end

  attr_reader :planes

end
