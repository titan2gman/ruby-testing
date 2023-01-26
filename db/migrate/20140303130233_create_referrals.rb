class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.string :name
      t.string :email
      t.references :contact, index: true

      t.timestamps
    end
  end
end
