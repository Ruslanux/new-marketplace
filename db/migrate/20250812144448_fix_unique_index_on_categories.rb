class FixUniqueIndexOnCategories < ActiveRecord::Migration[8.0]
  def change
    # FIXED: Added `if_exists: true` to safely remove indexes
    # This prevents errors if an index doesn't exist.
    remove_index :categories, :name, if_exists: true
    remove_index :categories, :slug, if_exists: true

    # Then, add new partial unique indexes that only apply to active records
    add_index :categories, :name, unique: true, where: "discarded_at IS NULL"
    add_index :categories, :slug, unique: true, where: "discarded_at IS NULL"
  end
end
