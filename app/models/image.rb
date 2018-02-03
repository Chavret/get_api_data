class Image < ApplicationRecord

  ##############################################################################

  # BELONGS TO

  belongs_to :product

  ##############################################################################

  # SCOPE

  scope :by_product, ->(product) { where(product_id: product.id) }

  ##############################################################################

  # VALIDATION
end
