# frozen_string_literal: true

require 'eltiempo/client/errors/missing_api_key_error'
require 'eltiempo/client/errors/negative_id_error'
require 'eltiempo/client/errors/non_numeric_id_error'
require 'eltiempo/client/errors/response_not_ok_error'
require 'eltiempo/client/errors/standard_api_error'
require 'eltiempo/client/errors/wrong_content_type_error'
require 'eltiempo/parser/response_parser'
require 'http'

module Eltiempo
  @@base_url = 'https://api.tiempo.com/index.php'

  ##
  #  Retrieves the base api's url, used for retrieving
  #  the weather's data.
  def self.base_url
    @@base_url
  end

  ##
  #  Sets +new_url+ as the base api's url, from where's weather data
  #  is fetch.
  def self.base_url=(new_url)
    @@base_url = new_url
  end

  ##
  #  Client class for connecting to `eltiempo` API and retrieving
  #  weather data from it.
  #
  #  Uses https://github.com/httprb/http as an HTTP client
  class Client
    @@api_key = ENV['TIEMPO_API_KEY']
    @@mime_types = %w{text/xml text/javascript application/json}

    ##
    #  Checks whether the `TIEMPO_API_KEY` env variable is set
    #  for the current client
    def self.api_key?
      !!@@api_key
    end

    ##
    #  Default getter of the api_key value used for the calls
    def self.api_key
      @@api_key
    end

    ##
    #  Creates the Client's instance that will pull data from
    #  the eltiempo's api, and convert it using the +parser+
    def initialize(parser)
      @parser = parser
      @api_url = "#{Eltiempo::base_url}?affiliate_id=#{Eltiempo::Client.api_key}"
    end

    ##
    # Gets a Division's locations by its +division_id+ in the system,
    # pulling them from the api. An optional +division_name+ can be passed
    # to assign it to the returned Division
    #
    # raises MissingApiKeyError if the api_key is not set
    # raises NegativeIdError if the +division_id+ is negative number
    # raises NonNumericIdError if +division_id+ is not an integer
    # raises StandardApiError if the +parser+ encounters an ApiErrorDto
    # raises WrongContentType if the response has a not supported content type
    # raises ResponseNotOkError if the response's code is not 200
    #
    # returns an array of locations
    def get_locations_from_division_id(division_id, division_name = '')
      basic_checks(division_id)
      response = HTTP.get("#{@api_url}&division=#{division_id}")
      validate_if_api_error(response)
      @parser.division_with_locations_from_xml(
        response.body.to_s,
        division_name,
        division_id,
      )
    end

    ##
    # Gets a Location's weather, as a DaysGroupWeather,
    # by its +location_id+ in the system. 
    #
    # raises MissingApiKeyError if the api_key is not set
    # raises NegativeIdError if the +division_id+ is negative number
    # raises NonNumericIdError if +division_id+ is not an integer
    # raises StandardApiError if the +parser+ encounters an ApiErrorDto
    # raises WrongContentType if the response has a not supported content type
    # raises ResponseNotOkError if the response's code is not 200
    def get_weather_from_location_id(location_id)
      basic_checks(location_id)
      # version 3.0 of the endpoint returns a json object
      # which is easier to parse
      response = HTTP.get("#{@api_url}&localidad=#{location_id}&v=3.0")
      validate_if_api_error(response)
      @parser.daysweather_from_json(response.body.to_s)
    end

    private

      ##
      #  Checks if the requirements for a proper request
      #  to the api, using the +id+, are met.
      #
      # raises MissingApiKeyError if the api_key is not set
      # raises NegativeIdError if the +id+ is negative number
      # raises NonNumericIdError if +id+ is not an integer
      def basic_checks(id)
        raise Eltiempo::MissingApiKeyError unless Eltiempo::Client.api_key?
        raise Eltiempo::NonNumericIdError unless id.is_a? Numeric
        raise Eltiempo::NegativeIdError unless id >= 0
      end

      ##
      #  Checks if the obtained response is valid in terms
      #  of code, content_type and message's data
      #
      # raises WrongContentType if the response has a not supported content type
      # raises ResponseNotOkError if the response's code is not 200
      #
      # returns an ApiErrorDto when the response is invalid,
      # otherwise returns nil
      def validate_response(response)
        raise Eltiempo::ResponseNotOkError unless response.code == 200
        content_type = response.content_type
        mime_type = content_type.mime_type if content_type
        unless mime_type && @@mime_types.include?(mime_type)
          raise Eltiempo::WrongContentTypeError
        end
        body = response.body.to_s
        case mime_type
        when 'text/javascript', 'application/json'
          @parser.check_if_error_json body
        # XML (as the inclusion is already checked by the include? on L125)
        else
          @parser.check_if_error_xml body
        end
      end

      ##
      #  Checks if the obtained response is valid in terms of the basic structure
      #  of the xml/json object obtained
      #
      # raises StandardApiError if the +parser+ encounters an ApiErrorDto
      def validate_if_api_error(response)
        errored = validate_response(response)
        raise Eltiempo::StandardApiError.new(errored.error) if errored.is_a? ApiErrorDto
      end
  end
end

