class AddDiscardToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :discarded_at, :datetime
    add_index :categories, :discarded_at
  end
end
