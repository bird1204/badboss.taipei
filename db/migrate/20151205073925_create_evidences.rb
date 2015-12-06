class CreateEvidences < ActiveRecord::Migration
  def change
    create_table :evidences do |t|
      t.string :resource_id
      t.string :image

      t.timestamps null: false
    end
  end
end
