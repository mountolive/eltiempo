# frozen_string_literal: true

module Eltiempo

  ##
  #  Thrown when a wrapped error is thrown by the eltiempo's api,
  #  these usually come in a 200 response, with a message int the tag (xml) 
  #  `error`, or in the parameter "error" of the json response (v=3.0
  #  on weather's endpoint)
  class StandardApiError < StandardError
    def initialize(msg = 'The request returned an error from the api')
      super
    end
  end
end

