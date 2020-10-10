# frozen_string_literal: true

class Location
  attr_accessor :week_weather

  def initialize(name, id, url, week_weather = [])
    @name = name
    @id = id
    @url = url 
    @week_weather = week_weather
  end
end
