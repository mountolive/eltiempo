# frozen_string_literal: true

module Tiempo
  class MissingApiKeyError < StandardError
    def initialize(msg='Please set TIEMPO_API_KEY env variable')
      super
    end
  end
end
