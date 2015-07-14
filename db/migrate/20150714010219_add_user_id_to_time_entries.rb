class AddUserIdToTimeEntries < ActiveRecord::Migration
  def change
    change_table :time_entries do |t|
      t.integer :user_id
      t.index :user_id
    end
  end
end
