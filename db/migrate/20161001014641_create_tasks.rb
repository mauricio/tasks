class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :task_lists do |t|
      t.string :title, null: false
      t.text :tasks
    end

    add_index :task_lists, :title, unique: true
  end
end
