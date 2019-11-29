class StatusForEachProfileInMatch < ActiveRecord::Migration[6.0]
  def change
    rename_column :matches, :status, :status1
    add_column :matches, :status2, :integer
  end
end
