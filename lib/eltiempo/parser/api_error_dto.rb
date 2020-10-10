# frozen_string_literal: true

module Eltiempo
  class ApiErrorDto
    attr_reader :error
    def initialize(error_msg)
      @error = error_msg
    end
  end
end
