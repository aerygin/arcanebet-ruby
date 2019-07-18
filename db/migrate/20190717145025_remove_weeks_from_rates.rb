# frozen_string_literal: true

class RemoveWeeksFromRates < ActiveRecord::Migration[5.2]
  def change
    remove_column :rates, :weeks, :string
  end
end
