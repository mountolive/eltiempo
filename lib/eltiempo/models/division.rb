# frozen_string_literal: true

module Tiempo
  class Division
    attr_accessor :locations

    def initialize(name, id, locations = nil)
      @name = name
      @id = id
      @locations = locations
    end

    def has_locations?
      !!@locations
    end
  end
end
