class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.integer  :milestone
      t.datetime :started_at
      t.datetime :stopped_at
      t.integer  :duration
      t.text     :json
      t.timestamps null: false
    end
  end
end
