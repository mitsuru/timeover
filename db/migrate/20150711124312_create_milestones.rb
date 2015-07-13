class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.integer :user_id
      t.string :title
      t.datetime :start_at
      t.datetime :end_at
      t.string :state
      t.integer :budget
      t.integer :budget_time

      t.timestamps null: false

      t.index :state
    end
  end
end
