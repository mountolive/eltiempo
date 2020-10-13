# frozen_string_literal: true

module Eltiempo

  ##
  #  Thrown when the api returns a content not supported by the
  #  current client ("text/javascript", "text/xml",
  #  "application/json")
  class WrongContentTypeError < StandardError
    def initialize(msg = 'Response with not supported content type')
      super
    end
  end
end

