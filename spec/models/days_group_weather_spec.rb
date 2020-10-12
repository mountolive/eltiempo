# frozen_string_literal: true

require 'date'
require 'eltiempo/models/day_weather'
require 'eltiempo/models/days_group_weather'
require 'eltiempo/models/errors/days_not_set_error'
require 'eltiempo/models/errors/today_not_listed_error'

require 'spec_helper'

describe Eltiempo::DaysGroupWeather do
  before(:all) do
    @days = [
      Eltiempo::DayWeather.new(10, 19, Date.today),
      Eltiempo::DayWeather.new(15, 30, Date.parse('20201010')),
      Eltiempo::DayWeather.new(11, 20, Date.parse('20201001')),
    ]
    @group = Eltiempo::DaysGroupWeather.new @days
    @empty_days_group = Eltiempo::DaysGroupWeather.new []
    @nil_days_group = Eltiempo::DaysGroupWeather.new nil
  end

  context 'todays_temperature' do
    it 'should return the average from current day' do
      expect(@group.todays_temperature).to eq 14
    end

    it 'should raise an error if @days parameter is not set' do
      expect { @nil_days_group.todays_temperature }.to(
        raise_error(Eltiempo::DaysNotSetError)
      )
    end

    it 'should raise error if today is not in @days' do
      not_today_group = Eltiempo::DaysGroupWeather.new [@days[1]]
      expect { not_today_group.todays_temperature }.to(
        raise_error(Eltiempo::TodayNotListedError)
      )
    end
  end

  context 'average_min_temperature' do
    it 'should return the average min temp of the group' do
      expect(@group.average_min_temperature).to eq 12
    end

    it 'should raise an error if @days parameter is not set' do
      expect { @nil_days_group.average_min_temperature }.to(
        raise_error(Eltiempo::DaysNotSetError)
      )
    end

    it 'should raise an error if @days parameter is empty' do
      expect { @empty_days_group.average_min_temperature }.to(
        raise_error(Eltiempo::DaysNotSetError)
      )
    end
  end

  context 'average_max_temperature' do
    it 'should return the average max temp of the group' do
      expect(@group.average_max_temperature).to eq 23
    end

    it 'should raise an error if @days parameter is not set' do
      expect { @nil_days_group.average_max_temperature }.to(
        raise_error(Eltiempo::DaysNotSetError)
      )
    end

    it 'should raise an error if @days parameter is empty' do
      expect { @empty_days_group.average_max_temperature }.to(
        raise_error(Eltiempo::DaysNotSetError)
      )
    end
  end
end
