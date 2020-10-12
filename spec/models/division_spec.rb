# frozen_string_literal: true

require 'eltiempo/models/division'
require 'eltiempo/models/location'

require 'spec_helper'

describe Eltiempo::Division do
  before(:each) do
    @division = Eltiempo::Division.new 'Barcelona', 102
  end

  context 'has_locations?' do
    it 'should return false' do
      expect(@division.has_locations?).to eq false
    end

    it 'should return true' do
      set_test_location(@division)
      expect(@division.has_locations?).to eq true
    end
  end

  context 'get_location' do
    it 'should return nil when the division has no locations' do
      expect(@division.get_location('test')).to be nil
    end

    it 'should return nil when the location is not registered' do
      set_test_location(@division, 'other')
      expect(@division.get_location('test')).to be nil
    end

    it 'should return a proper location when it\'s registered, uppercase' do
      set_test_location(@division)
      location = @division.get_location('TEST')
      check_location(location)
    end

    it 'should return a proper location when it\'s registered, lowercase' do
      set_test_location(@division)
      location = @division.get_location('test')
      check_location(location)
    end

    it 'should return a proper location when it\'s registered, mix casing' do
      set_test_location(@division)
      location = @division.get_location('tEsT')
      check_location(location)
    end
  end
end

def set_test_location(division, name = 'test')
  location = Eltiempo::Location.new('Test', 25, 'test')
  division.locations = {name => location}
end

def check_location(location)
  expect(location).not_to be nil
  expect(location.id).to eq 25
  expect(location.name).to eq 'Test'
  expect(location.url).to eq 'test'
end
