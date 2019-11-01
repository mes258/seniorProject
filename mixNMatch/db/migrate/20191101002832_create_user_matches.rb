class CreateUserMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :user_matches do |t|
        t.references :user, null: false, foreign_key: true
        t.references :match, null: false, foreign_key: true
        t.timestamps
    end
  end
end
