# frozen_string_literal: true

require "test_helper"

class ActiveJobTest < ActionDispatch::IntegrationTest
  test "connects to resque's redis" do
    assert_not_nil(Resque.redis.server_time)
  end
end
