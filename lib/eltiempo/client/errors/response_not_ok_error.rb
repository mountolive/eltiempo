# frozen_string_literal: true

module Eltiempo
  class ResponseNotOkError < StandardError
    def initialize(msg = 'Response returned a status code different than 200')
      super
    end
  end
end

