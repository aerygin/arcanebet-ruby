# frozen_string_literal: true

class Rate < ApplicationRecord
  include HTTParty


  belongs_to :user
  default_scope { order(created_at: :desc) }

  validates :amount, presence: true,
                     format: { with: /\A\d+(?:\.\d{0,2})?\z/ }
  validates :weeks, presence: true,
                    numericality: { greater_than: 0, less_than_or_equal_to: 25 }
  #AVAILABLE_CURRENCIES = %w(AUD BGN BRL CAD CHF CNY CZK DKK EUR GBP HKD HRK HUF IDR ILS INR JPY KRW MXN MYR NOK NZD PHP PLN RON RUB SEK SGD THB TRY USD ZAR)
  AVAILABLE_CURRENCIES = %w(EUR USD GBP)
  ACCESS_KEY = Rails.application.credentials.api_free_access_key

  def calculation
    sorted_result_array = get_sorted_result
    today_rate = find_today_rate(sorted_result_array)
    sorted_result_array.each do |item|
      item.merge!(push_data_to_response(item))
      item.merge!(:test => today_rate)
      item.merge!(:difference => calculate_profit_loss(today_rate, item))
    end
    sorted_result_array
  end

  def get_sorted_result
    Rails.cache.fetch("/rates/#{id}-#{updated_at}/", :expires_in => 12.hours) do
    result = []
    date = Time.now.utc.to_date
    date_str = date.strftime('%Y-%m-%d')
    weeks.times do
        response_from_api = fixer_request(date_str)
        if response_from_api.parsed_response["success"]
          result.push(response_from_api.parsed_response)
          date = date - 7
          date_str = date.strftime('%Y-%m-%d')
        end
      end
    result.sort {|b, a| a['date'] <=> b['date']}
    end
  end

  def fixer_request(date_str)
    self.class.get('http://data.fixer.io/api/' + date_str + '?access_key=' + ACCESS_KEY +
                       '&base=' + base_currency + '&symbols=' + target_currency,
                   :headers => {'Content-Type' => 'application/json'})
  end


  def push_data_to_response(item)
    exchange_rate = item["rates"][target_currency]
    converted_amount = amount * exchange_rate
    Hash[:converted_amount, '%f' % converted_amount,
         :week_nr, get_week_nr(item),
         :exchange_rate, exchange_rate]
  end

  def generate_collection_for_chart(array)
    array.collect {|i| [i["date"], i["rates"][target_currency]]}
  end

  def calculate_profit_loss (today, item)
    item[:converted_amount].to_f - (today * amount)
  end

  def find_today_rate(array)
    if array.length > 0
      array[0]['rates'][target_currency]
    end
  end

  def find_max_rate(array)
    array.max_by {|x| x[:exchange_rate]}[:exchange_rate]
  end

  def find_min_rate(array)
    array.min_by {|x| x[:exchange_rate]}[:exchange_rate]
  end

  def get_week_nr(item)
    date = item["date"]
    Date.parse(date).strftime('%U').to_i
  end
end
