# frozen_string_literal: true

require 'test_helper'

class RateTest < ActiveSupport::TestCase
  setup do
    @rate = Rate.new
  end

  test 'base_currency is required' do
    assert_not @rate.valid_attribute? :base_currency
  end

  test 'target_currency is required' do
    assert_not @rate.valid_attribute? :target_currency
  end

  test 'amount is required' do
    assert_not @rate.valid_attribute? :amount
  end

  test 'weeks is required' do
    assert_not @rate.valid_attribute? :weeks
  end

  test 'amount is decimal' do
    @rate.amount = 100.1001
    assert_not @rate.valid_attribute? :amount
  end

  test 'weeks is numerical' do
    @rate.weeks = 'abc'
    assert_not @rate.valid_attribute? :weeks
  end

  test 'weeks is greater than 0' do
    @rate.weeks = -1
    assert_not @rate.valid_attribute? :weeks
  end

  test 'weeks is less than 25' do
    @rate.weeks = 26
    assert_not @rate.valid_attribute? :weeks
  end
end
