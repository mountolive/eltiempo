# frozen_string_literal: true

require 'errors'
require 'parser'

module Eltiempo
  @@base_url = 'https://api.tiempo.com/index.php'

  def self.base_url
    @@base_url
  end

  def self.base_url=(new_url)
    @@base_url = new_url
  end

  class Client
    @@api_key = ENV['TIEMPO_API_KEY']
    @@api_url = "#{self.base_url}?affiliate_id=#{@@api_key}"

    def self.api_key?
      !!@@api_key
    end

    def initialize
      @parser = ResponseParser.new
    end

    def get_division(division_id)
      # TODO It's going to return the basic Division
    end

    def get_location_weather(location_id)
      # TODO Will return a WeekWeather instance
    end
  end
end

