class GiveProfilesContactMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :contact_info, :text
  end
end
