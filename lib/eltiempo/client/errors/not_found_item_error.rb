# frozen_string_literal: true

module Tiempo
  class NotFoundItemError < StandardError
    def initialize(msg='The id passed is not associated to any location/division')
      super
    end
  end
end

