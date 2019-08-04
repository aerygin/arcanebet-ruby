# frozen_string_literal: true

module Fixer
  class Result
    attr_reader :response

    def initialize(rate, response)
      @rate = rate
      @response = response
    end

    def success?
      @response.any?
    end

    def chart_data
      @chart_data ||= @response.collect { |i| [i['date'], i['rates'][target_currency]] }
    end

    def today_rate
      @today_rate ||= @response[0]['rates'][target_currency] if success?
    end

    def max_rate
      @max_rate ||= @response.max_by { |x| x[:exchange_rate] }[:exchange_rate]
    end

    def min_rate
      @min_rate ||= @response.min_by { |x| x[:exchange_rate] }[:exchange_rate]
    end

    def target_currency
      @rate.target_currency
    end
  end
end
