# frozen_string_literal: true

module Eltiempo

  ##
  #  Exception thrown when today's date is not listed in a
  #  DaysGroupWeather
  class TodayNotListedError < StandardError
    def initialize(msg = 'The list of days doesn\'t contain today\'s data')
      super
    end
  end
end
