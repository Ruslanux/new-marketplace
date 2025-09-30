class Category < ApplicationRecord
  include Discard::Model

  has_many :products, dependent: :destroy

  # FIXED: Updated the uniqueness validation to ignore archived records.
  validates :name, presence: true, uniqueness: { scope: :discarded_at }
  validates :slug, presence: true, uniqueness: { scope: :discarded_at }

  default_scope -> { kept }

  before_validation :generate_slug

  private

  def generate_slug
    self.slug = name&.parameterize
  end
end
