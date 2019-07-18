# frozen_string_literal: true

require 'application_system_test_case'

class RatesTest < ApplicationSystemTestCase
   test 'visiting the index' do
     visit rates_url

     assert_selector 'h1', text: 'Rates'
   end
end
