class CreateGuiltResouces < ActiveRecord::Migration
  def change
    create_table :guilt_resouces do |t|
      t.string :guilt_id
      t.string :resources_id

      t.timestamps null: false
    end
  end
end
