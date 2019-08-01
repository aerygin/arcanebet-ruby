# frozen_string_literal: true

require 'test_helper'

class RateTest < ActiveSupport::TestCase
  RATE = Rate.new(amount: 100,
                  user_id: 5,
                  weeks: 2,
                  base_currency: 'EUR',
                  target_currency: 'RUB')
  RESULT = [
    {
      'success' => true, 'timestamp' => 1_564_577_766,
      'historical' => true, 'base' => 'EUR',
      'date' => '2019-07-31', 'rates' => { 'RUB' => 70.79799 },
      :converted_amount => '7079.799000', :week_nr => 30,
      :exchange_rate => 70.79799, :test => 70.79799, :difference => 0.0
    },
    {
      'success' => true, 'timestamp' => 1_564_012_799,
      'historical' => true, 'base' => 'EUR',
      'date' => '2019-07-24', 'rates' => { 'RUB' => 70.507008 },
      :converted_amount => '7050.700800', :week_nr => 29,
      :exchange_rate => 70.507008, :test => 70.79799, :difference => -0.290982e2
    }
  ].freeze

  test 'week number validation' do
    assert_not Rate.new(amount: 100, user_id: 5, weeks: '123').save
  end

  test 'check handle fixer request' do
    rate = Rate.new(amount: 100,
                    user_id: 5,
                    weeks: 2,
                    base_currency: 'EUR',
                    target_currency: 'USD')
    result = rate.handle_fixer_request
    date = Time.now.utc.to_date
    date_str = date.strftime('%Y-%m-%d')
    assert_equal(date_str, result[0]['date'])
  end

  test 'check find min rate' do
    array = [{ exchange_rate: 20 }, { exchange_rate: 50 }]
    assert_equal(20, RATE.find_min_rate(array))
  end

  test 'check find max rate' do
    array = [{ exchange_rate: 20 }, { exchange_rate: 50 }]
    assert_equal(50, RATE.find_max_rate(array))
  end

  test 'check find today rate' do
    assert_equal(70.79799, RATE.find_today_rate(RESULT))
  end

  test 'check get week nr' do
    assert_equal(30, RATE.find_week_nr(RESULT[0]))
  end

  test 'calculate profit loss' do
    assert_equal(RESULT[1][:difference],
                 RATE.calculate_profit_loss(RESULT[0][:exchange_rate],
                                            RESULT[1]))
  end

  test 'fixer request' do
    rate = Rate.new(amount: 100,
                    user_id: 5,
                    weeks: 1,
                    base_currency: 'EUR',
                    target_currency: 'USD')
    response = rate.fixer_request('2019-07-01')
    assert_equal(true, response['success'])
  end

  test 'collection for chart' do
    result = RATE.generate_collection_for_chart(RESULT)
    assert_equal('2019-07-31', result[0][0])
  end

  test 'push data to response' do
    item = { 'date' => '2019-07-31', 'rates' => { 'RUB' => 70.79799 } }
    final_response = RATE.push_data_to_response(item)
    assert_not_equal(nil, final_response[:week_nr])
  end

  test 'add to cache' do
    rate = Rate.new(amount: 100,
                    user_id: 5,
                    weeks: 1,
                    base_currency: 'EUR',
                    target_currency: 'USD')
    assert_not_equal(nil, rate.cached_result)
  end

  test 'calculation ' do
    assert_not_equal(nil,RATE.calculation)
  end
end
