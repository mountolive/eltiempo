# frozen_string_literal: true

require 'spec_helper'
require 'eltiempo/models/location'
require 'eltiempo/models/day_weather'
require 'eltiempo/models/days_group_weather'
require 'eltiempo/parser/api_error_dto'
require 'eltiempo/parser/response_parser'

describe 'Eltiempo::ResponseParser' do
  before(:all) do
    # For comparison
    @day = Eltiempo::DayWeather.new(15, 20)
    @location = Eltiempo::Location.new('Abrera', 1182, '')
    @errored = Eltiempo::ApiErrorDto.new 'ERROR'
 
    #Strings
    @division_res = %q{
      <report>
        <location city="Listado de localidades - Provincia de Barcelona" num="627" 
         level="3" level_name="Localidad">
           <data>
             <name id="1182">Abrera</name>
             <url>http://api.tiempo.com/index.php?api_lang=es&localidad=1182</url>
           </data>
        </location>
      </report>
    }
    @error_res_xml = %q{
      <report>
        <error>ERROR</error>
      </report>
    }
    @error_res_json = %q{
    {"status":1,"error":"ERROR"}
    }
    @weather_res_json = %q{
      {
        "status": 0,
        "location": "Abrera [Provincia de Barcelona;España]",
        "url": "https://www.tiempo.com/abrera.htm",
        "day": {
                 "1": {
                       "tempmin": "15",
                       "tempmax": "20"
                      }
        }
      }
    }
    @weather_res_xml = %q{
      <report>
        <location city="Abrera [Provincia de Barcelona;España]">
          <interesting>
            <url description="Predicción">https://www.tiempo.com/abrera.htm</url>
          </interesting>
          <var>
            <name>Temperatura Mínima</name>
            <icon>4</icon>
            <data>
              <forecast data_sequence="1" value="15"/>
            </data>
          </var>
          <var>
            <name>Temperatura Máxima</name>
            <icon>5</icon>
            <data>
              <forecast data_sequence="1" value="20"/>
            </data>
          </var>
        </location>
      </report>
    }

    # The parser
    @parser = Eltiempo::ResponseParser.new
  end

  context 'locations_from_xml' do
    it 'should create Locations from division xml' do
      parsed_value = @parser.locations_from_xml(@division_res)
      expect(parsed_value).not_to be_a(Eltiempo::ApiErrorDto)
      expect(parsed_value).to be_a(Array)
      expect(parsed_value.size).to eq 1
      location = parsed_value.first
      expect(location).not_to be nil
      expect(location.id).to eq @location.id
      expect(location.name).to eq @location.name
      expect(location.url).to eq @location.url
      expect(location.week_weather).to be_a(Array)
    end
  end

  context 'daysweather_from_xml' do
    it 'should create DaysGroupWeather from location xml' do
      parsed_value = @parser.daysweather_from_xml(@weather_res_xml)
      check_weekweather(parsed_value, @day)
    end
  end

  context 'daysweather_from_json' do
    it 'should create DaysGroupWeather from location json' do
      parsed_value = @parser.daysweather_from_json(@weather_res_json)
      check_weekweather(parsed_value, @day)
    end
  end

  context 'check_if_error_xml' do
    it 'should return nil if the data is not an error' do
      expect(@parser.check_if_error_xml(@weather_res_xml)).to be nil
    end

    it 'should create ApiErrorDto from api\'s error xml' do
      parsed_value = @parser.check_if_error_xml(@error_res_xml)
      expect(parsed_value).to be_a(Eltiempo::ApiErrorDto)
      expect(parsed_value.error).to eq @errored.error
    end
  end

  context 'check_if_error_json' do
    it 'should return nil if the data is not an error' do
      expect(@parser.check_if_error_json(@weather_res_json)).to be nil
    end

    it 'should create ApiErrorDto from api\'s error json' do
      parsed_value = @parser.check_if_error_json(@error_res_json)
      expect(parsed_value).to be_a(Eltiempo::ApiErrorDto)
      expect(parsed_value.error).to eq @errored.error
    end
  end
end

def check_weekweather(parsed_value, expected_day)
  expect(parsed_value).not_to be_a(Eltiempo::ApiErrorDto)
  expect(parsed_value).to be_a(Eltiempo::DaysGroupWeather)
  expect(parsed_value.days).to be_a(Array)
  expect(parsed_value.days.size).to eq 1
  day = parsed_value.days.first
  expect(day).not_to be nil
  expect(day.min_temp).to eq expected_day.min_tmp
  expect(day.max_tmp).to eq expected_day.max_tmp
end
