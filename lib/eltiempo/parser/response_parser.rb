# frozen_string_literal: true

require 'json'
require 'ox'
require 'eltiempo/models/day_weather'
require 'eltiempo/models/days_group_weather'
require 'eltiempo/models/location'
require 'eltiempo/parser/api_error_dto'
require 'eltiempo/parser/errors/missing_days_array_error'
require 'eltiempo/parser/errors/report_not_present_error'

module Eltiempo

  ##
  #  Helper class that parses usual responses from eltiempo's API
  #  to regular data objects (defined in '../models')
  class ResponseParser

    ##
    #  Checks whether the received xml object, as +xmldata+,
    #  from the api is an error object.
    #
    #  throws ReportNotPresentError if the root tag of the object
    #  (`report`) is missing
    #
    #  Returns nil if it's not an error object
    def check_if_error_xml(xmldata)
      report = get_report(xmldata)
      err_msg = report[:error]
      return unless err_msg
      ApiErrorDto.new err_msg
    end

    ##
    #  Checks whether the received json object, as +jsondata+,
    #  from the api is an error objecti.
    #
    #  Returns nil if it's not an error object
    def check_if_error_json(jsondata)
      #  The reason for this procedure is that
      #  the api returns errors also with 200 HTTP code.
      json_hash = JSON.parse(jsondata)
      err_msg = json_hash['error']
      return unless err_msg
      ApiErrorDto.new err_msg
    end

    ##
    #  Parses a Location's XML response, +xmldata+ to an array of Location
    #
    #  throws ReportNotPresentError if the root tag of the object
    #  (`report`) is missing
    def locations_from_xml(xmldata)
      #  Note: as for the api, Location's rpc only supports XML format
      #  in its responses
      report = get_report(xmldata)
      raw_locations = report[:location]
      # Missing the location tag. First element in array is
      # current division's info
      if raw_locations.nil? || raw_locations.empty? || raw_locations.length < 2
        return []
      end

      # The reason to return a slice instead of a map directly
      # is to decoupling Division/Client/ResponseParser

      # We filter out instead of simple slicing
      # to guard ourselves of changes on te document's order
      raw_locations.filter { |elem| !!elem[:data] }.map do |data|
        hash_to_location(data)
      end
    end

    ##
    #  Parses a DayWeather's JSON response, 
    #  +jsondata+ to a DaysGroupWeather instance
    #
    #  raises MissingDaysArrayError if the `day` parameter is not
    #  present in the object
    def daysweather_from_json(jsondata)
      # The json response is more parsing-friendly than the xml one
      json_hash = JSON.parse(jsondata)
      days_arr = json_hash["day"]
      raise Eltiempo::MissingDaysArrayError unless days_arr
      parsed_days = days_arr.values.map { |day| hash_to_day(day) }
      Eltiempo::DaysGroupWeather.new parsed_days
    end

    private
      ##
      #  Converts hash +data+ to Location
      def hash_to_location(data)
        content = data[:data]
        name = content[:name][1]
        id = content[:name][0][:id].to_i
        url = content[:url]
        Eltiempo::Location.new name, id, url
      end

      ##
      #  Converts hash +day+ to DayWeather
      def hash_to_day(day)
        Eltiempo::DayWeather.new(
          day["tempmin"].to_f,
          day["tempmax"].to_f,
          Date.parse(day["date"]),
        )
      end

      ##
      #  Checks existence of `report` tag and returns it if present
      #  +xmldata+ is the string of the XML to be parsed
      #
      #  throws ReportNotPresentError if the tag is not present in the hash
      def get_report(xmldata)
        #  The reason for this procedure is that
        #  the api returns errors also with 200 HTTP code.
        xml_hash = Ox.load(xmldata, mode: :hash)
        report = xml_hash[:report]
        raise Eltiempo::ReportNotPresentError unless report
        report
      end
  end
end
