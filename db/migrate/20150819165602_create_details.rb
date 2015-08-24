class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.string :filename
      t.string :status
      t.string :preference

      t.timestamps null: false
    end
  end
end
