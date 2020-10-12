# frozen_string_literal: true

module Eltiempo

  ##
  #  Exception thrown when the `report` tag is not
  #  present in a xml response
  class ReportNotPresentError < StandardError
    def initialize(msg = 'Missing `report` tag from response\'s xml')
      super
    end
  end
end
