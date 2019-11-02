class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.string :song
      t.integer :preference
      t.integer :gender
      t.integer :value
      t.integer :priority

      t.timestamps
    end
  end
end
