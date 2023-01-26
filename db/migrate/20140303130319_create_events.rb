class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :contact, index: true
      t.references :associated, index: true, polymorphic: true
      t.integer :points
      t.text :description

      t.timestamps
    end
  end
end
