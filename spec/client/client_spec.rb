# frozen_string_literal: true

require 'eltiempo/client/client'
require 'eltiempo/client/errors/missing_api_key_error'
require 'eltiempo/client/errors/negative_id_error'
require 'eltiempo/client/errors/non_numeric_id_error'
require 'eltiempo/client/errors/response_not_ok_error'
require 'eltiempo/client/errors/standard_api_error'
require 'eltiempo/client/errors/wrong_content_type_error'
require 'eltiempo/parser/api_error_dto'
require 'eltiempo/parser/response_parser'
require 'http'

require 'mock_parser'
require 'spec_helper'

describe Eltiempo::Client do
  before(:all) do
    @client = Eltiempo::Client.new MockParser.new
    @non_existing = 9999999999
    @wrong_key = 'wrong-key'
    @non_numeric = 'wrong'
    @negative = -1
    @division_id = 102
    @location_id = 1182
    @mock_error_dto = Eltiempo::ApiErrorDto.new 'Mock error'
  end

  context 'get_locations_from_division_id' do
    it 'should raise WrongContentTypeError when response is invalid type' do
      allow_any_instance_of(HTTP::ContentType).to receive(:mime_type).and_return('bad')
      VCR.use_cassette('bad-mime-type-division') do
        expect { @client.get_locations_from_division_id(@division_id) }.to(
          raise_error(Eltiempo::WrongContentTypeError)
        )
      end
    end

    it 'should raise ResponseNotOkError when response\'s code is not 200' do
      allow_any_instance_of(HTTP::Response).to receive(:code).and_return(400)
      VCR.use_cassette('bad-response-division') do
        expect { @client.get_locations_from_division_id(@division_id) }.to(
          raise_error(Eltiempo::ResponseNotOkError)
        )
      end
    end

    it 'should error if api_key is not set' do
      allow(Eltiempo::Client).to receive(:api_key?).and_return(false)   
      expect { @client.get_locations_from_division_id(@division_id) }.to(
        raise_error(Eltiempo::MissingApiKeyError)
      )
    end

    it 'should error for non-numeric division_id' do
      expect { @client.get_locations_from_division_id(@non_numeric) }.to(
        raise_error(Eltiempo::NonNumericIdError)
      )
    end

    it 'should error for negative division_id' do
      expect { @client.get_locations_from_division_id(@negative) }.to(
        raise_error(Eltiempo::NegativeIdError)
      )
    end

    it 'should error for non-existing division_id' do
      allow_any_instance_of(MockParser).to receive(:check_if_error_xml).and_return(@mock_error_dto)
      VCR.use_cassette('wrong-division-id') do
        expect { @client.get_locations_from_division_id(@non_existing) }.to(
          raise_error(Eltiempo::StandardApiError)
        )
      end
    end

    it 'should retrieve division properly' do
      VCR.use_cassette('correct-division-id') do
        division = @client.get_locations_from_division_id(@division_id)
        expect(division.locations).not_to be nil
        expect(division.id).to be @division_id
      end
    end
  end

  context 'get_weather_from_location_id' do
    it 'should raise WrongContentTypeError when response is invalid type' do
      allow_any_instance_of(HTTP::ContentType).to receive(:mime_type).and_return('bad')
      VCR.use_cassette('bad-mime-type-location') do
        expect { @client.get_weather_from_location_id(@location_id) }.to(
          raise_error(Eltiempo::WrongContentTypeError)
        )
      end
    end

    it 'should raise ResponseNotOkError when response\'s code is not 200' do
      allow_any_instance_of(HTTP::Response).to receive(:code).and_return(400)
      VCR.use_cassette('bad-response-location') do
        expect { @client.get_weather_from_location_id(@location_id) }.to(
          raise_error(Eltiempo::ResponseNotOkError)
        )
      end
    end

    it 'should error if api_key is not set' do
      allow(Eltiempo::Client).to receive(:api_key?).and_return(false)   
      expect { @client.get_weather_from_location_id(@location_id) }.to(
        raise_error(Eltiempo::MissingApiKeyError)
      )
    end

    it 'should error for non-numeric location_id' do
      expect { @client.get_weather_from_location_id(@non_numeric) }.to(
        raise_error(Eltiempo::NonNumericIdError)
      )
    end

    it 'should error for negative location_id' do
      expect { @client.get_weather_from_location_id(@negative) }.to(
        raise_error(Eltiempo::NegativeIdError)
      )
    end

    it 'should error for non-existing location_id' do
      allow_any_instance_of(MockParser).to receive(:check_if_error_json).and_return(@mock_error_dto)
      VCR.use_cassette('wrong-location-id') do
        expect { @client.get_weather_from_location_id(@non_existing) }.to(
          raise_error(Eltiempo::StandardApiError)
        )
      end
    end

    it 'should retrieve location\'s weather properly' do
      VCR.use_cassette('correct-location-id') do
        week_weather = @client.get_weather_from_location_id(@location_id)
        expect(week_weather).not_to be nil
        expect(week_weather.days).not_to be_empty
      end
    end
  end

  context 'basic integration' do
    before(:all) do
      # Using actual parser to check if api's response is as expected
      @integration_client = Eltiempo::Client.new Eltiempo::ResponseParser.new
    end

    it 'should error for non-existing location_id, [integration]' do
      VCR.use_cassette('wrong-location-id') do
        expect { @integration_client.get_weather_from_location_id(@non_existing) }.to(
          raise_error(Eltiempo::StandardApiError)
        )
      end
    end

    it 'should error if api_key is invalid, get_weather_from_location_id, [integration]' do
      allow(Eltiempo::Client).to receive(:api_key).and_return(@wrong_key)
      local_client = Eltiempo::Client.new Eltiempo::ResponseParser.new
      VCR.use_cassette('wrong-api-key') do
        expect { local_client.get_weather_from_location_id(@location_id) }.to(
          raise_error(Eltiempo::StandardApiError)
        )
      end
    end

    it 'should error for non-existing division_id, [integration]' do
      VCR.use_cassette('wrong-division-id') do
        expect { @integration_client.get_locations_from_division_id(@non_existing) }.to(
          raise_error(Eltiempo::StandardApiError)
        )
      end
    end

    it 'should error if api_key is invalid, get_locations_from_division_id, [integration]' do
      allow(Eltiempo::Client).to receive(:api_key).and_return(@wrong_key)
      local_client = Eltiempo::Client.new Eltiempo::ResponseParser.new
      VCR.use_cassette('wrong-api-key') do
        expect { local_client.get_locations_from_division_id(@division_id) }.to(
          raise_error(Eltiempo::StandardApiError)
        )
      end
    end
  end
end
