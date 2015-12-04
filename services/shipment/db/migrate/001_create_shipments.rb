class CreateShipments < ActiveRecord::Migration
  def up
    create_table :shipments do |t|
      t.integer :item_id
      t.integer :amount
      t.string :address
      t.timestamps
    end
  end

  def down
    drop_table :shipments
  end
end
