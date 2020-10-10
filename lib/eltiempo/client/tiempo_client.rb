# frozen_string_literal: true

BASE_URL = 'https://api.tiempo.com/index.php'

class TiempoClient
  @@api_key = ENV['TIEMPO_API_KEY']
  @@api_url = "#{BASE_URL}?affiliate_id=#{@@api_key}"

  include ResponseParser

  def get_division(division_id)
    # TODO It's going to return the basic Division
  end

  def get_location_weather(location_id)
    # TODO Will return a WeekWeather instance
  end
end

