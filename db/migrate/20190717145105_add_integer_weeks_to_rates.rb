# frozen_string_literal: true

class AddIntegerWeeksToRates < ActiveRecord::Migration[5.2]
  def change
    add_column :rates, :weeks, :integer
  end
end
