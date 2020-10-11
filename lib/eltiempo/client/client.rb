# frozen_string_literal: true

require 'eltiempo/parser/response_parser'

module Eltiempo
  @@base_url = 'https://api.tiempo.com/index.php'

  ##
  #  Retrieves the base api's url, used for retrieving
  #  the weather's data.
  def self.base_url
    @@base_url
  end

  ##
  #  Sets +new_url+ as the base api's url, from where's weather data
  #  is fetch.
  def self.base_url=(new_url)
    @@base_url = new_url
  end

  ##
  #  Client class for connecting to `eltiempo` API and retrieving
  #  weather data from it.
  class Client
    @@api_key = ENV['TIEMPO_API_KEY']
    @@api_url = "#{Eltiempo::base_url}?affiliate_id=#{@@api_key}"

    ##
    #  Checks whether the `TIEMPO_API_KEY` env variable is set
    #  for the current client
    def self.api_key?
      !!@@api_key
    end

    def initialize
      @parser = Eltiempo::ResponseParser.new
    end

    def get_division(division_id)
      # TODO It's going to return the basic Division
    end

    def get_location_weather(location_id)
      # TODO Will return a WeekWeather instance
    end
  end
end

