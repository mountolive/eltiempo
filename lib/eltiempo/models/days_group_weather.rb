# frozen_string_literal: true

require 'date'
require 'eltiempo/models/errors/days_not_set_error'
require 'eltiempo/models/errors/today_not_listed_error'

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
    #  throws DaysNotSetError if the +days+ array is not set or if it's
    #  empty.
    def todays_temperature
      raise Eltiempo::DaysNotSetError if @days.nil? || @days.empty?
      today = Date.today
      # It should be the first element in the array, but this
      # lookup guards us from possible changes in the response
      # order-wise
      today_location = @days.find { |day| day.date == today }
      raise Eltiempo::TodayNotListedError unless today_location
      today_location.average_temperature
    end

    ##
    #  Calculates the average minimum temperature of the group of days,
    #  +days+.
    #
    #  throws DaysNotSetError if the +days+ array is not set or if it's
    #  empty.
    def average_min_temperature
      raise Eltiempo::DaysNotSetError if @days.nil? || @days.empty?
      @days.map(&:min_temp).reduce(:+) / @days.length.to_f
    end

    ##
    #  Calculates the average maximum temperature of the group of days,
    #  +days+.
    #
    #  throws DaysNotSetError if the +days+ array is not set or if it's
    #  empty.
    def average_max_temperature
      raise Eltiempo::DaysNotSetError if @days.nil? || @days.empty?
      @days.map(&:max_temp).reduce(:+) / @days.length.to_f
    end
  end
end

