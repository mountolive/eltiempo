# frozen_string_literal: true

require 'eltiempo/models/errors/wrong_temperatures_error'

module Eltiempo
  ##
  #  This class holds the data and methods related to temperature
  #  range of a given day.

  class DayWeather
    attr_reader :min_temp, :max_temp

    #
    ##
    #  Creates a new DayWeather,
    #  which holds the max a min temperature of a given day.
    #  Convention is to use Celsius degrees although not mandatory
    #
    #  An WrongTemperaturesError is thrown
    #  if the min temperature passed is greater than the max temperature passed.

    def initialize(min_temp, max_temp)
      raise WrongTemperaturesError unless min_temp <= max_temp
      @min_temp = min_temp
      @max_temp = max_temp
    end

    ##
    #  Calculates the average temperature of this day

    def average_temperature
      (@min_temp + @max_temp) / 2
    end
  end
end
