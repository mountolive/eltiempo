# frozen_string_literal: true

module Eltiempo

  ##
  #  Signals that the TIEMPO_API_KEY is not set in the system
  class MissingApiKeyError < StandardError
    def initialize(msg = 'Please set TIEMPO_API_KEY env variable')
      super
    end
  end
end
