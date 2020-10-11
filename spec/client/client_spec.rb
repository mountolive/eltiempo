# frozen_string_literal: true

require 'eltiempo/client/client'
require 'eltiempo/client/errors/missing_api_key_error'
require 'eltiempo/client/errors/negative_id_error'
require 'eltiempo/client/errors/non_numeric_id_error'
require 'eltiempo/client/errors/standard_api_error'

require 'spec_helper'

describe 'Eltiempo::Client' do
  before(:all) do
    @client = Eltiempo::Client.new
    @non_existing = 9999999999
    @wrong_key = 'wrong-key'
    @non_numeric = 'wrong'
    @negative = -1
    @division_id = 102
    @location_id = 1182
  end

  context 'get_division' do
    it 'should error if api_key is not set' do
      allow(Eltiempo::Client).to receive(:api_key?).and_return(false)   
      expect(@client.get_division(@division_id)).to(
        raise_error(Eltiempo::MissingApiKeyError)
      )
    end

    it 'should error if api_key is invalid' do
      ENV['TIEMPO_API_KEY'] = @wrong_key
      local_client = Eltiempo::Client.new
      VCR.use_cassette('wrong-api-key') do
        expect(local_client.get_division(@division_id)).to(
          raise_error(Eltiempo::StandardApiError)
        )
      end
    end

    it 'should error for non-numeric division_id' do
      expect(@client.get_division(@non_numeric)).to(
        raise_error(Eltiempo::NonNumericIdError)
      )
    end

    it 'should error for negative division_id' do
      expect(@client.get_division(@negative)).to(
        raise_error(Eltiempo::NegativeIdError)
      )
    end

    it 'should error for non-existing division_id' do
      VCR.use_cassette('wrong-division-id') do
        expect(@client.get_division(@non_existing)).to(
          raise_error(Eltiempo::StandardApiError)
        )
      end
    end

    it 'should retrieve division properly' do
      VCR.use_cassette('correct-division-id') do
        division = @client.get_division(@division_id)
        expect(division.locations).not_to be nil
        expect(division.id).to be @division_id
      end
    end
  end

  context 'get_location_weather' do
    it 'should error if api_key is not set' do
      allow(Eltiempo::Client).to receive(:api_key?).and_return(false)   
      expect(@client.get_location_weather(@location_id)).to(
        raise_error(Eltiempo::MissingApiKeyError)
      )
    end

    it 'should error if api_key is invalid' do
      ENV['TIEMPO_API_KEY'] = @wrong_key
      local_client = Eltiempo::Client.new
      VCR.use_cassette('wrong-api-key') do
        expect(local_client.get_location_weather(@location_id)).to(
          raise_error(Eltiempo::StandardApiError)
        )
      end
    end

    it 'should error for non-numeric location_id' do
      expect(@client.get_location_weather(@non_numeric)).to(
        raise_error(Eltiempo::NonNumericIdError)
      )
    end

    it 'should error for negative location_id' do
      expect(@client.get_location_weather(@negative)).to(
        raise_error(Eltiempo::NegativeIdError)
      )
    end

    it 'should error for non-existing location_id' do
      VCR.use_cassette('wrong-location-id') do
        expect(@client.get_location_weather(@non_existing)).to(
          raise_error(Eltiempo::StandardApiError)
        )
      end
    end

    it 'should retrieve location\'s weather properly' do
      VCR.use_cassette('correct-location-id') do
        week_weather = @client.get_location_weather(@location_id)
        expect(week_weather).not_to be nil
        expect(week_weather.days).not_to be_empty
      end
    end
  end
end
