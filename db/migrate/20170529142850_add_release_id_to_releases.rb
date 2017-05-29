class AddReleaseIdToReleases < ActiveRecord::Migration[5.0]
  def change
    add_column :releases, :release_id, :integer
  end
end
