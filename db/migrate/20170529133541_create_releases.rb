class CreateReleases < ActiveRecord::Migration[5.0]
  def change
    create_table :releases do |t|
      t.string :name
      t.string :artist
      t.string :url
      t.string :embed
      t.string :release_number
      t.string :release_medium
    end
  end
end
