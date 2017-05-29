class CreateMerch < ActiveRecord::Migration[5.0]
  def change
    create_table :merches do |t|
      t.string :name
      t.string :medium
      t.string :price
      t.boolean :sold_out
    end
  end
end
