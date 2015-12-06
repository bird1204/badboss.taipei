class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :owner
      t.integer :number
      t.datetime :registered
      t.integer :good_count
      t.integer :bad_count
      t.text :website

      t.timestamps null: false
    end
  end
end
