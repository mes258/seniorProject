class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.integer :profile1_id
      t.integer :profile2_id
      t.integer :status

      t.timestamps
    end
  end
end
