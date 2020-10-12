# frozen_string_literal: true

require 'eltiempo/models/day_weather'
require 'eltiempo/models/days_group_weather'
require 'eltiempo/models/division'
require 'eltiempo/models/location'

##
#  Mock parser class for injecting into the Client,
#  for testing purposes
class MockParser

  ## Creates an instance and sets default values
  def initialize
    days = [Eltiempo::DayWeather.new(10, 20, Date.today)]
    @daysweather = Eltiempo::DaysGroupWeather.new days
    @division = Eltiempo::Division.new('Barcelona', 102)
    @division.add_location(Eltiempo::Location.new('Test', 1182))
  end

  ## Returns nil
  def check_if_error_json(jsondata); end

  ## Returns nil
  def check_if_error_xml(xmldata); end

  ## Returns default location 
  def division_with_locations_from_xml(xmldata, div_name, div_id)
    @division
  end

  ## Returns default DaysGroupWeather
  def daysweather_from_json(jasondata)
    @daysweather
  end
end

