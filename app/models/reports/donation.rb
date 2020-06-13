# frozen_string_literal: true

module Reports
  class Donation < Base
    def receipts
      @recipts ||= Receipt.completed
                          .where(delivered_at: start_date..end_date)
                          .where(destination_type: 'ExternalEntity')
    end

    def products
    end
  end
end
