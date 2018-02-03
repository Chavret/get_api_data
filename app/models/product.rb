class Product < ApplicationRecord

  ##############################################################################

  # HAS MANY

  has_one :image, foreign_key: :product_id

  has_one :statistic, foreign_key: :product_id
end
