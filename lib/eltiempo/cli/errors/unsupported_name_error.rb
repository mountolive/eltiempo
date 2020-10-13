# frozen_string_literal: true

module Eltiempo

  ##
  #  Signals that a flag passed to a cli script is invalid
  #  +name+ should be the invalidating flag
  class UnsupportedNameError < StandardError
    def initialize(name = '')
      super("The flag #{name} is invalid")
    end
  end
end
