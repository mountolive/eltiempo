# frozen_string_literal: true

module Eltiempo

  ##
  #  Data object used to hold any error message prompted by the Api
  class ApiErrorDto
    attr_reader :error
    def initialize(error_msg)
      @error = error_msg
    end
  end
end
