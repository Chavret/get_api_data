class CreateImage < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string :url
      t.integer :naturalHeight
      t.integer :width
      t.integer :naturalWidth
      t.integer :height
      t.integer :product_id
      t.integer :position
      t.string :path
    end
  end
end
