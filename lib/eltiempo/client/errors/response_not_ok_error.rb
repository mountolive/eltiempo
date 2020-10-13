# frozen_string_literal: true

module Eltiempo

  ##
  #  Thrown when the api returns a response with status
  #  code different than 200 (ok)
  class ResponseNotOkError < StandardError
    def initialize(msg = 'Response returned a status code different than 200')
      super
    end
  end
end

