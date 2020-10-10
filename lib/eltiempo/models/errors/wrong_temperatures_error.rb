# frozen_string_literal: true

module Eltiempo
  class WrongTemperaturesError < StandardError
    def initialize(msg = 'Min temperature should be less or eq than Max temperature')
      super
    end
  end
end
