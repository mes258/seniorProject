class AddNames < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :first, :string
    add_column :profiles, :last, :string
  end
end
