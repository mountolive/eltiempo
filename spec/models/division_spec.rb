# frozen_string_literal: true

require 'spec_helper.rb'

describe 'Eltiempo::Division' do
  before(:all) do
    @division = Eltiempo::Division.new 'Barcelona', 102
  end

  context 'has_locations?' do
    it 'should return false' do
      expect(@division.has_locations?).to eq false
    end

    it 'should return true' do
      location = Eltiempo::Location('Test', 25, 'test')
      @division.locations = {'test' => location}
      expect(@division.has_locations?).to eq true
    end
  end
end
