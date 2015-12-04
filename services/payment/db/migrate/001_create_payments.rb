class CreatePayments < ActiveRecord::Migration
  def up
    create_table :payments do |t|
      t.integer :price
      t.integer :item_id
      t.integer :amount
      t.timestamps
    end
  end

  def down
    drop_table :payments
  end
end
