class Weather

  def initialize
    @weather = weather_outlook
  end

  def stormy?
    @weather == :stormy
  end

  OUTLOOKS = [:stormy, :fine, :fine, :fine, :fine]

  def weather_outlook
    OUTLOOKS.sample
  end
end