# frozen_string_literal: true

require 'spec_helper.rb'

describe 'Eltiempo::DaysGroupWeather' do
  before(:all) do
    @days = [
      Eltiempo::DayWeather.new(10, 19),
      Eltiempo::DayWeather.new(15, 30),
      Eltiempo::DayWeather.new(11, 20),
    ]
    @group = Eltiempo::DaysGroupWeather.new(@days)
  end

  context 'todays_temperature' do
    it 'should return the average from current day' do
      expect(@group.todays_temperature).to eq 15
    end
  end

  context 'average_min_temperature' do
    it 'should return the average min temp of the group' do
      expect(@group.average_min_temperature).to eq 12
    end
  end

  context 'average_max_temperature' do
    it 'should return the average max temp of the group' do
      expect(@group.average_max_temperature).to eq 23
    end
  end
end
