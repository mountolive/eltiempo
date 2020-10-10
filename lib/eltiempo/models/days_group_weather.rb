# frozen_string_literal: true

module Eltiempo
  class DaysGroupWeather
    attr_reader :days

    def initialize(days)
      @days = days
    end

    def todays_temperature
      # TODO Implement
    end

    def average_min_temperature
      # TODO implement
    end

    def average_max_temperature
      # TODO implement
    end
  end
end

