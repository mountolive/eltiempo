# frozen_string_literal: true

module Eltiempo

  ##
  #  Thrown when trying to a pass a non-numeric value to
  #  an function that connects to an endpoint in eltiempo's API
  #  which accepts only integers
  class NonNumericIdError < StandardError
    def initialize(msg = 'The id passed has to be a number')
      super
    end
  end
end

