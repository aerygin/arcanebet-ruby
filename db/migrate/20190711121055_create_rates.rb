class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.string :base_currency
      t.string :target_currency
      t.decimal :amount
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
