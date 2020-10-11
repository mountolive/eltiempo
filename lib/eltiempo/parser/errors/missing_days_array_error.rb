# frozen_string_literal: true

module Eltiempo

  ##
  #  Exception thrown when the `report` tag is not
  #  present in a xml response
  class MissingDaysArrayError < StandardError
    def initialize(msg = 'The parameter `days` is not present in the current weather data')
      super
    end
  end
end
