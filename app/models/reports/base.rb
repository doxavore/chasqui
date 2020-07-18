# frozen_string_literal: true

module Reports
  class Base
    attr_reader :start_date, :end_date

    def self.current(only_all = false)
      Rails.cache.fetch("#{name}/current", expires_in: 10.minutes) do
        reports = { all: new.to_h }
        return reports if only_all

        historical.merge(reports)
      end
    end

    def self.historical
      {
        daily: new(1.day.ago).to_h,
        weekly: new(1.week.ago).to_h,
        monthly: new(1.month.ago).to_h
      }
    end

    def initialize(start_date = 1.year.ago, end_date = Time.zone.now)
      @start_date = start_date
      @end_date = end_date
    end
  end
end
