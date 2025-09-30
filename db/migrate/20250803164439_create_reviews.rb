class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :comment, null: false

      t.timestamps
    end

    add_index :reviews, [ :user_id, :product_id ], unique: true
    add_index :reviews, [ :product_id, :created_at ]
  end
end
