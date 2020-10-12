# frozen_string_literal: true

module Eltiempo
  class WrongContentTypeError < StandardError
    def initialize(msg = 'Response with not supported content type')
      super
    end
  end
end

