# frozen_string_literal: true

module Eltiempo

  ##
  #  Data object that holds information about a given division
  #  from the api (i.e. 'Barcelona').
  class Division
    attr_reader :locations

    ##
    #  Creates a Division instance with passed +name+ and +id+ associated
    #
    #  +locations+ if nil by default. It should be a hash { name => Location }
    #  if passed, it will transform all keys to lower case
    def initialize(name, id, locations = nil)
      @name = name
      @id = id
      set_locations(locations) if locations
    end

    ##
    #  Checks wether the +locations+ hash is set in this Division
    #  instance.
    #
    #  Returns false either when there's no +locations+ set or
    #  if the hash is empty.
    def has_locations?
      !!@locations && !@locations.empty?
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
      return nil unless has_locations?
      @locations[name.downcase]
    end

    ## Alias method for setting locations
    def locations=(locations)
      set_locations(locations)
    end

    private
      def set_locations(locations)
        @locations = {}
        locations.each { |k, v| @locations[k.downcase] = v }
      end
  end
end
