# frozen_string_literal: true

require 'eltiempo/models/errors/days_not_set_error'

module Eltiempo

  ##
  #  This class groups DayWeather instances and operates over them,
  #  it is, hence, basically a wrapper for a DayWeather array
  class DaysGroupWeather
    attr_accessor :days

    ##
    #  Creates a DaysGroupWeather instances that holds the passed
    #  +days+, a DayWeather array corresponding to a given group of days
    #  weather data
    def initialize(days)
      @days = days
    end

    ##
    #  Calculates the temperature of the current day.
    #
    #  It is assumed that the current day is the first element in the
    #  +days+ array.
    #
    #  throws EmptyDaySetError if the +days+ array is not set or if it's
    #  empty.
    def todays_temperature
      raise Eltiempo::DaysNotSetError if @days.nil? || @days.empty?
      @days.first.average_temperature
    end

    ##
    #  Calculates the average minimum temperature of the group of days,
    #  +days+.
    #
    #  throws EmptyDaySetError if the +days+ array is not set or if it's
    #  empty.
    def average_min_temperature
      raise Eltiempo::DaysNotSetError if @days.nil? || @days.empty?
      @days.map(&:min_temp).reduce(:+) / @days.length.to_f
    end

    ##
    #  Calculates the average maximum temperature of the group of days,
    #  +days+.
    #
    #  throws EmptyDaySetError if the +days+ array is not set or if it's
    #  empty.
    def average_max_temperature
      raise Eltiempo::DaysNotSetError if @days.nil? || @days.empty?
      @days.map(&:max_temp).reduce(:+) / @days.length.to_f
    end
  end
end

