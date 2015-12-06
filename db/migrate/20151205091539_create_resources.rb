class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :acord_type
      t.string :acord_content

      t.timestamps null: false
    end
  end
end
