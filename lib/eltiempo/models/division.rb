# frozen_string_literal: true

module Eltiempo
  class Division
    attr_accessor :locations

    def initialize(name, id, locations = nil)
      @name = name
      @id = id
      @locations = locations
    end

    def has_locations?
      !!@locations && !@locations.empty?
    end

    def get_location(name)
      return nil unless has_locations?
      @locations[name.downcase]
    end
  end
end
