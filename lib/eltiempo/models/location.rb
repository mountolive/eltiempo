# frozen_string_literal: true

module Eltiempo

  ##
  #  Data object that holds basic information of a location
  #
  #  It relates to a Division in a many-to-one manner.
  class Location
    attr_reader :id, :name, :url

    ##
    #  Creates a Location instance given the +name+ of the Location
    #  +id+ in the system and +url+ which is the url to follow
    #  in the api to get DaysGroupWeather information about the Location
    def initialize(name, id, url)
      @name = name
      @id = id
      @url = url
    end
  end
end
