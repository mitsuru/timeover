class AddStartToUserPreference < ActiveRecord::Migration
  def change
    add_column :user_preferences, :start, :datetime
  end
end
