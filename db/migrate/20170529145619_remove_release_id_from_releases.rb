class RemoveReleaseIdFromReleases < ActiveRecord::Migration[5.0]
  def change
    remove_column :releases, :release_id, :integer
  end
end
