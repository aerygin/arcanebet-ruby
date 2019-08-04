# frozen_string_literal: true

require 'test_helper'

class FixerResultServiceTest < ActiveSupport::TestCase
  RATE = Rate.new(amount: 100,
                  user_id: 5,
                  weeks: 2,
                  base_currency: 'EUR',
                  target_currency: 'RUB')

  setup do
    @result = ::Fixer::Service.new(RATE).calculate
  end

  test 'calculation was successful' do
    assert_equal(true, @result.response.any?)
  end

  test 'first date in array is today date' do
    date = Time.now.utc.to_date
    date_str = date.strftime('%Y-%m-%d')
    assert_equal(date_str, @result.response[0]['date'])
  end

  test 'result length test' do
    assert_equal(2, @result.response.length)
  end
end