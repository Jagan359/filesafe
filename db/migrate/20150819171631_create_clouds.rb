class CreateClouds < ActiveRecord::Migration
  def change
    create_table :clouds do |t|
      t.string :drop
      t.string :box
      t.string :goog
      t.string :filenm

      t.timestamps null: false
    end
  end
end
