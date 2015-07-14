class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.integer :user_id
      t.text :preferences

      t.timestamps null: false
    end
  end
end
