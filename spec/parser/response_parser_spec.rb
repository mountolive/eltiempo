# frozen_string_literal: true

require 'spec_helper.rb'

describe 'ResponseParser' do
  before(:all) do
    # For comparison
    day = Eltiempo::DayWeather.new
    day.min_temp = 20
    day.max_temp = 32
    @days = [day]
    @week = Eltiempo::WeekWeather.new
    @week.days = @days
    @location = [Eltiempo::Location.new('Abrera', 1182, '')]
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
    @error_res = %q{
      <report>
        <error>ERROR</error>
      </report>
    }
    @weather_res = %q{
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
  end

end
