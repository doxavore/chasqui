# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActiveJob do
  describe "Resque" do
    it "connects to redis" do
      expect(Resque.redis.server_time).not_to eq(nil)
    end
  end
end
