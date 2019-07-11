class AddTargetCurAndAmmountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :target_currency, :string
    add_column :users, :amount, :string
  end
end
