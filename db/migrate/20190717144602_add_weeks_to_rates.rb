# frozen_string_literal: true

class AddWeeksToRates < ActiveRecord::Migration[5.2]
  def change
    add_column :rates, :weeks, :string
  end
end
