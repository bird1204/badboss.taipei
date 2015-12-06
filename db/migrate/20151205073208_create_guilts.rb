class CreateGuilts < ActiveRecord::Migration
  def change
    create_table :guilts do |t|
      t.string :name
      t.string :company_id

      t.timestamps null: false
    end
  end
end
