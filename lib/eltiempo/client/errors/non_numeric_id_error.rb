# frozen_string_literal: true

module Eltiempo
  class NonNumericIdError < StandardError
    def initialize(msg = 'The id passed has to be a number')
      super
    end
  end
end

