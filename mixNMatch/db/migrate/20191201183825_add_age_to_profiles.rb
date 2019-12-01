class AddAgeToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :age, :int, :default => 20
  end
end
