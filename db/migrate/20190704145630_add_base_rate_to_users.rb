# frozen_string_literal: true

class AddBaseRateToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :base_currency, :string
  end
end
