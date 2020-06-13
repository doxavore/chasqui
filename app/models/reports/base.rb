# frozen_string_literal: true

module Reports
  class Base
    attr_reader :start_date, :end_date

    def initialize(start_date = 1.year.ago, end_date = Time.now)
      @start_date = start_date
      @end_date = end_date
    end
  end
end
