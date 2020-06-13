# frozen_string_literal: true

module Reports
  class Base
    attr_reader :start_date, :end_date

    def self.current
      Rails.cache.fetch("#{name}/current", expires_in: 10.minutes) do
        {
          daily: new(1.day.ago).to_h,
          weekly: new(1.week.ago).to_h,
          monthly: new(1.month.ago).to_h,
          all: new.to_h
        }
      end
    end

    def initialize(start_date = 1.year.ago, end_date = Time.zone.now)
      @start_date = start_date
      @end_date = end_date
    end
  end
end
