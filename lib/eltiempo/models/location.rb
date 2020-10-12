# frozen_string_literal: true

module Eltiempo

  ##
  #  Data object that holds basic information of a location
  class Location
    attr_reader :id, :name, :url

    ##
    #  Creates a Location instance given the +name+ of the Location
    #  +id+ in the system, used to get DaysGroupWeather information
    #  about the Location.
    #  An +url+ associated to the location's place in the api can
    #  optionally be passed
    def initialize(name, id, url = nil)
      @name = name
      @id = id
      @url = url
    end
  end
end
