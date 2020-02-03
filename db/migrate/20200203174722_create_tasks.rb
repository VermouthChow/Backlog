class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :title,                                    null: false 
      t.text :content,                                    null: false 
      t.string :priority,                                 array: true
      t.integer :priority_weight,                         null: false, default: 0
      t.integer :status,                                  null: false
      t.timestamps
      t.belongs_to :user
    
    end

    add_index :tasks, :title,                             using: :gin
    add_index :tasks, :content,                           using: :gin
    add_index :tasks, :priority_weight
    add_index :tasks, :status

  end
end
