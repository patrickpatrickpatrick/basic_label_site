class AddReleaseIdFromReleasesAsString < ActiveRecord::Migration[5.0]
  def change
    add_column :releases, :release_id, :string
  end
end
