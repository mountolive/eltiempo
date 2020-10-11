# frozen_string_literal: true

module Eltiempo

  ##
  #  Exception thrown when Max Temperature +max_temp+
  #  is less than Min Temperature +min_temp+ for a DayWeather
  class WrongTemperaturesError < StandardError
    def initialize(msg = 'Min temperature should be less or eq than Max temperature')
      super
    end
  end
end
