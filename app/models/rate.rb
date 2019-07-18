# frozen_string_literal: true

class Rate < ApplicationRecord
  belongs_to :user
  default_scope { order(created_at: :desc) }

  validates :amount, presence: true,
                     format: { with: /\A\d+(?:\.\d{0,2})?\z/ }
  validates :weeks, presence: true,
                    numericality: { greater_than: 0, less_than_or_equal_to: 25 }
  AVAILABLE_CURRENCIES = %w(AUD BGN BRL CAD CHF CNY CZK DKK EUR GBP HKD HRK HUF IDR ILS INR JPY KRW MXN MYR NOK NZD PHP PLN RON RUB SEK SGD THB TRY USD ZAR)
end
