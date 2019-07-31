# frozen_string_literal: true

require 'test_helper'

class RateTest < ActiveSupport::TestCase
   test "the truth" do
     assert true
   end


  test "week number validation should trigger " do
    assert_not Rate.new(amount: 100, user_id: 5,  weeks: "123").save
  end

end
