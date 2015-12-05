class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.boolean :good_or_bad
      t.string :company_id
      t.string :voting_ip

      t.timestamps null: false
    end
  end
end
