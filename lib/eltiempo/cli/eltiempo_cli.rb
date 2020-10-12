# frozen_string_literal: true

require 'eltiempo/client/client'
require 'eltiempo/client/errors/missing_api_key_error'
require 'eltiempo/client/errors/response_not_ok_error'
require 'eltiempo/client/errors/standard_api_error'
require 'eltiempo/models/division'
require 'thor'


module Eltiempo
  class EltiempoCLI < Thor

    ##
    #  Basic command for retrieval of temperature data,
    #  in Celsius degrees, from the eltiempo's api, for the
    #  cities of Barcelona, through +city_name+
    option(:today, type: :boolean, 
           desc: 'Returns the average temperature of today for the passed city')
    option(:av_max, type: :boolean, 
           desc: 'Returns the average maximum temperature of the week for the passed city')
    option(:av_min, type: :boolean,
           desc: 'Returns the average minimum temperature of the week for the passed city')
    def barcelona_temperature(city_name)
    end
  end
end
