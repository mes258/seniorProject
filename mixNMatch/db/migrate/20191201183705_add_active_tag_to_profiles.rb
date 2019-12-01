class AddActiveTagToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :active, :boolean, :default => true
  end
end
