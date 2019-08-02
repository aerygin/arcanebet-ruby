# frozen_string_literal: true

require 'test_helper'

class RatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rate = rates(:one)
    @user = users(:one)
  end

  test 'show rate' do
    get rate_url(@rate)
    assert_response :success
  end

  test 'destroy rate' do
    assert_difference('Rate.count', -1) do
      delete rate_url(@rate)
    end
    assert_redirected_to rates_path
  end

  test 'show edit rate' do
    get edit_rate_url(@rate)
    assert_response :success
  end

  test 'show new rate' do
    get new_rate_url(@rate)
    assert_response :success
  end

  test 'test' do
    get '/rates/new'
    assert_response :success

    #     post "/rates" ,
    #         params: {base_currency: "EUR", target_currency: "USD", amount: 10 , weeks: 10, user_id: @user.id}
    #     assert_response :redirect
  end
end
