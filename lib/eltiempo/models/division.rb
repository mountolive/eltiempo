# frozen_string_literal: true

module Eltiempo

  ##
  #  Data object that holds information about a given division
  #  from the api (i.e. 'Barcelona').
  class Division
    attr_reader :id, :name, :locations

    ##
    #  Creates a Division instance with passed +name+ and +id+ associated
    def initialize(name, id)
      @name = name
      @id = id
      @locations = {}
    end

    ##
    #  Checks whether the +locations+ hash in this Division
    #  instance is empty or not.
    #
    #  Returns false if the +locations+ hash is empty.
    def has_locations?
      !@locations.empty?
    end

    ##
    #  Adds single Location to Division's locations register.
    #  It overrides any previous value, if already registered.
    #  The key in the hash would be the Location's name, downcased.
    #  Use `get_location` to case-insensitive retrieval
    def add_location(location)
      @locations[location.name.downcase] = location
    end

    ##
    #  Returns a Location given the passed +name+;
    #  the matching will be case-insensitive.
    #
    #  If no location is found, returns nil.
    #
    #  === Example
    #      location = { 'test' => Location }
    #      division.get_location('tEsT') will return `location`
    def get_location(name)
      @locations[name.downcase]
    end

    ##
    #  Alias method for setting locations
    #  +locations+ should be a hash { location.name => Location }
    #  when added, every key will be downcased
    def locations=(locations)
      locations.each { |k, v| @locations[k.downcase] = v }
    end
  end
end
