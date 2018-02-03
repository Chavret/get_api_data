class CreateStatistic < ActiveRecord::Migration[5.0]
  def change
    create_table :statistics do |t|
      t.string :dimension
      t.string :language
      t.integer :product_id
      t.string :collection
      t.string :poche
      t.string :classement
    end
  end
end
