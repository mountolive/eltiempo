# frozen_string_literal: true

require 'date'
require 'eltiempo/models/errors/wrong_temperatures_error'

module Eltiempo

  ##
  #  This class holds the data and methods related to the temperature
  #  range of a given day.
  class DayWeather
    attr_reader :min_temp, :max_temp, :date

    #
    ##
    #  Creates a new DayWeather,
    #  which holds the +max_temp+ (max temperature) a +min_temp+(min temperature) of a given +date+.
    #  Convention is to use Celsius degrees although not mandatory
    #
    #  A WrongTemperaturesError is thrown
    #  if the +min_temp+ passed is greater than the +max_temp+ passed.
    def initialize(min_temp, max_temp, date)
      raise Eltiempo::WrongTemperaturesError unless min_temp <= max_temp
      @min_temp = min_temp
      @max_temp = max_temp
      @date = date
    end

    ##
    #  Calculates the average temperature of this day
    #  base on the values of +min_temp+ and +max_temp+
    def average_temperature
      (@min_temp + @max_temp) / 2
    end
  end
end
