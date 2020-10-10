# frozen_string_literal: true

module Eltiempo
  class InvalidApiKeyError < StandardError
    def initialize(msg='The provided api_key seems to be invalid. Aborting')
      super
    end
  end
end
