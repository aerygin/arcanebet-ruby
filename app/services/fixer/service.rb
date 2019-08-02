module Fixer
  class Service < ApplicationService
    include HTTParty

    ACCESS_KEY = ENV['FIXER_API_TOKEN']
    BASE_URL = 'http://data.fixer.io/api/'
    DEFAULT_TTL = 12.hours

    def initialize(rate)
      @rate = rate
    end

    def calculate
      Rails.cache.fetch("/rates/#{@rate.id}-#{@rate.updated_at}/", expires_in: DEFAULT_TTL) do
        calculate_rate
      end
    end

    private

    def calculate_rate
      sorted_result_array = handle_fixer_request
      today_rate = find_today_rate(sorted_result_array)
      sorted_result_array.each do |item|
        item.merge!(push_data_to_response(item))
        item.merge!(difference: calculate_profit_loss(today_rate, item))
      end
      Result.new(@rate, sorted_result_array)
    end

    def handle_fixer_request
      result = []
      date = Time.now.utc.to_date
      date_str = date.strftime('%Y-%m-%d')
      @rate.weeks.times do
        response_from_api = fixer_request(date_str)
        next unless response_from_api.parsed_response['success']

        result.push(response_from_api.parsed_response)
        date_str = (date -= 7).strftime('%Y-%m-%d')
      end
      result.sort { |b, a| a['date'] <=> b['date'] }
    end

    def fixer_request(date_str)
      self.class.get(BASE_URL + date_str +
                         '?access_key=' + access_key +
                         '&base=' + base_currency +
                         '&symbols=' + target_currency,
                     headers: { 'Content-Type' => 'application/json' })
    end

    def access_key
      return ACCESS_KEY if ACCESS_KEY

      raise ::StandardError, 'API token is required'
    end

    def find_today_rate(array)
      array[0]['rates'][target_currency] unless array.empty?
    end

    def push_data_to_response(item)
      exchange_rate = item['rates'][target_currency]
      converted_amount = amount * exchange_rate
      Hash[:converted_amount, '%f' % converted_amount,
           :week_nr, find_week_nr(item),
           :exchange_rate, exchange_rate]
    end

    def calculate_profit_loss(today, item)
      item[:converted_amount].to_f - (today * amount)
    end

    def base_currency
      @rate.base_currency
    end

    def target_currency
      @rate.target_currency
    end

    def amount
      @rate.amount
    end

    def find_week_nr(item)
      Date.parse(item['date']).strftime('%U').to_i
    end
  end
end
