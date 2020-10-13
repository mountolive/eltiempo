# frozen_string_literal: true

require 'eltiempo/client/client'
require 'eltiempo/client/errors/missing_api_key_error'
require 'eltiempo/client/errors/response_not_ok_error'
require 'eltiempo/client/errors/standard_api_error'
require 'eltiempo/client/errors/wrong_content_type_error'
require 'eltiempo/models/division'

module Eltiempo

  ##
  #  CLI Wrapper for retrieval of weekly temperature from cities
  #  in Barcelona
  class BarcelonaCLI
    @@division_id = 102
    @@division_name = 'Barcelona'
    @@long_desc  = %q{
     The "eltiempo" cli retrieves the temperature of any city in Barcelona.
     It can prompt today's temperature, average minimum and/or average maximum
     weekly temperature, in Celsius degrees.

     Any combination of the following flags can be passed to the command (at least one should be passed)
 
     FLAGS
     --today, -today, -t    Will prompt today's temperature for the passed city.
     --av_max, -av_max, -u  Will prompt average maximum temperature of the week for that city.
     --av-min, -av_min, -d  Will prompt average minimum temperature of the week for that city.
     --help, -help, -h      Will prompt this help menu (Ignoring any other param)

     PARAMETER
        The Barcelona's city of which you want to retrieve its temperature
    }
    @@today_flags = %w{--today -today -t}
    @@av_max_flags = %w{--av_max -av_max -u}
    @@av_min_flags = %w{--av_min -av_min -d}
    @@help_flags = %w{--help -help -h}

    ##
    #  Creates a CLI instance.
    #  The +flag_parser+ will be used to parse the flags from the command line
    def initialize(flag_parser)
      @flag_parser = flag_parser
    end

    ## 
    #  Executes the main command of this CLI Class
    #  Parses the flags in +argv+ and executes accordingly.
    def start(argv)
      parse_flags argv
      help = @@help_flags.any? { |h| @flags[h] }
      show_help if help
      show_help unless @city
      show_help if @flags.empty?
      today = @@today_flags.any? { |t| @flags[t] } 
      av_max = @@av_max_flags.any? { |u| @flags[u] } 
      av_min = @@av_min_flags.any? { |d| @flags[d] } 
      barcelona_temperature(@city, today, av_max, av_min)
    end

    private
      
      ## 
      #  Uses the instance's parser to retrieve the flags and process them.
      #  It also parses the city to be retrieved by this CLI command 
      #  assinging them to the instance variables +city+ and +flags+
      def parse_flags(argv)
        @city, @flags = @flag_parser.extract_flags argv
      end

      ##
      #  Main CLI's command.
      #
      #  It takes the +city_name+ to be retrieved by the client
      #  (it should be a city in Barcelona).
      #
      #  +today+ is a boolean that signals that today's weather should be retrieved
      #  +av_max+ is a boolean that signals that the average maximum temperature of the week
      #           shouled be printed
      #  +av_min+ is a boolean that signals that the average minimum temperature of the week
      #           shouled be printed
      def barcelona_temperature(city_name, today, av_max, av_min)
        show_help unless today || av_max || av_min
        client = Eltiempo::Client.new Eltiempo::ResponseParser.new
        begin
          division = client.get_locations_from_division_id(@@division_id, @@division_name)
          location = division.get_location(city_name)
          if !location
            puts 'Location passed was not found 
                  (common error: check for accent marks in name, for example)'
            exit 1
          end
          week_weather = client.get_weather_from_location_id(location.id)
          puts "#{@@division_name}: Today's (#{Date.today}) temperature in #{location.name} is:
                #{week_weather.todays_temperature} celsius" if today
          puts "#{@@division_name}: Max temperature in #{location.name} for the week:
                #{week_weather.average_max_temperature} celsius" if av_max
          puts "#{@@division_name}: Min temperature in #{location.name} for the week: 
                #{week_weather.average_min_temperature} celsius" if av_min
          exit 0
        rescue Eltiempo::MissingApiKeyError => e
          puts 'Please set your `TIEMPO_API_KEY` environment variable in your system'
          exit 1
        rescue Eltiempo::ResponseNotOkError => e
          puts 'The request to the API returned a non-Ok code, aborting'
          exit 1
        rescue Eltiempo::WrongContentTypeError => e
          puts 'The response of the API as an unexpected content_type, aborting'
          exit 1
        rescue Eltiempo::StandardApiError => e
          puts "Seems like the api returned the following error: #{e.message}"
          exit 1
        rescue StandardError => e
          puts "An unknown error occurred (#{e.message}), aborting"
          exit 1
        end
      end
    
      ##
      #  Shows the instructions of the command
      def show_help
         puts @@long_desc
         exit 0
      end
  end
end
