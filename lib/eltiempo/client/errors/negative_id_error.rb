# frozen_string_literal: true

module Eltiempo
  class NegativeIdError < StandardError
    def initialize(msg='The id passed can\'t be negative')
      super
    end
  end
end

