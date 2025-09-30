class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :orders, [ :user_id, :created_at ]
  end
end
