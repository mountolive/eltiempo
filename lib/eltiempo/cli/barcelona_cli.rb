# frozen_string_literal: true

require 'eltiempo/client/client'
require 'eltiempo/client/errors/missing_api_key_error'
require 'eltiempo/client/errors/response_not_ok_error'
require 'eltiempo/client/errors/standard_api_error'
require 'eltiempo/client/errors/wrong_content_type_error'
require 'eltiempo/models/division'
require 'thor'


module Eltiempo
  ##
  #  CLI Wrapper for retrieval of weekly temperature from cities
  #  in Barcelona
  class BarcelonaCLI < Thor
    @@division_id = 102
    @@division_name = 'Barcelona'

    default_task :barcelona_temperature
    class_options :help, :boolean, desc: 'Prompts script\'s help'

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
    desc '[FLAGS] [CITY_NAME]', %q{Retrieves today\'s, average maximum and/or 
                                   minimum temperature from CITY_NAME,
                                   a city from Barcelona}
    def barcelona_temperature(city_name)
      show_help
      today = options[:today]
      av_max = options[:av_max]
      av_min = options[:av_min]
      show_help unless today && av_max && av_min
      client = Eltiempo::Client.new Eltiempo::ResponseParser.new
      begin
        division = client.get_locations_from_division_id(@@division_id, @@division_name)
        location = division.get_location(city_name)
        week_weather = client.get_location_weather(location.id)
        puts "#{@@division_name}: Today's temperature in #{location.name} is #{week_weather.todays_temperature} celsius" if today
        puts "#{@@division_name}: Max temperature in #{location.name} for the week: #{week_weather.average_max_temperature} celsius" if av_max
        puts "#{@@division_name}: Min temperature in #{location.name} for the week: #{week_weather.average_min_temperature} celsius" if av_min
      rescue Eltiempo::MissingApiKeyError => e
        puts 'Please set your `TIEMPO_API_KEY` environment variable in your system'
      rescue Eltiempo::ResponseNotOkError => e
        puts 'The request to the API returned a non-Ok code, aborting'
      rescue Eltiempo::WrongContentType => e
        puts 'The response of the API as an unexpected content_type, aborting'
      rescue Eltiempo::StandardApiError => e
        puts "Seems like the api returned a the following error: #{e.error}"
      rescue StandardError => e
        puts "An unknown error occurred (#{e.inspect}), aborting"
      end
    end
    
    private
      def show_help
         help(:barcelona_temperature) if options[:help]       
      end
  end
end
