class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.string :company_id
      t.text :keyword

      t.timestamps null: false
    end
  end
end
