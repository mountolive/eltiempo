# frozen_string_literal: true

require 'errors'

module Eltiempo
  class DayWeather
    attr_reader :min_temp, :max_temp

    def initialize(min_temp, max_temp)
      raise WrongTemperaturesError unless min_temp <= max_temp
      @min_temp = min_temp
      @max_temp = max_temp
    end

    def average_temperature
      # TODO implement
    end
  end
end
