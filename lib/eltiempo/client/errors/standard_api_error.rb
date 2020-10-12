# frozen_string_literal: true

module Eltiempo
  class StandardApiError < StandardError
    def initialize(msg = 'The request returned an error from the api')
      super
    end
  end
end

