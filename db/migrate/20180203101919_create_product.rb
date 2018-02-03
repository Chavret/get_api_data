class CreateProduct < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :text
      t.string :title
      t.string :price
    end
  end
end
