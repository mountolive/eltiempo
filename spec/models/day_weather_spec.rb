# frozen_string_literal: true

require 'date'
require 'eltiempo/models/day_weather'
require 'eltiempo/models/errors/wrong_temperatures_error'

require 'spec_helper'

describe Eltiempo::DayWeather do
  context '#new' do
    it 'should throw error when min_temp is greater than max_temp' do
      expect { Eltiempo::DayWeather.new(20, 19, Date.today) }.to(
        raise_error(Eltiempo::WrongTemperaturesError)
      )
    end

    it 'should instantiate DayWeather correctly' do
      day = Eltiempo::DayWeather.new 19, 20, Date.today
      expect(day).not_to be nil
      expect(day.min_temp).to eq 19
      expect(day.max_temp).to eq 20
    end
  end

  context 'average_temperature' do
    it 'should return proper avg temperature' do
      day = Eltiempo::DayWeather.new 10, 20, Date.today
      expect(day.average_temperature).to eq 15
    end
  end
end
