# frozen_string_literal: true

module Eltiempo

  ##
  #  Thrown when trying to connect to the eltiempo's api passing a
  #  negative Id
  class NegativeIdError < StandardError
    def initialize(msg = 'The id passed can\'t be negative')
      super
    end
  end
end

