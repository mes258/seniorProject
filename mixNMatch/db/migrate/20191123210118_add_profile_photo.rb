class AddProfilePhoto < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :pictureID, :string, :default => "default"
  end
end
