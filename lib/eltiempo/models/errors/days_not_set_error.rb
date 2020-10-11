# frozen_string_literal: true

module Eltiempo

  ##
  #  Exception thrown when a DayWeather array is empty or nil
  class DaysNotSetError < StandardError
    def initialize(msg = '@days array is empty or nil')
      super
    end
  end
end
