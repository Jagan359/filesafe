class AddColumnToDetail < ActiveRecord::Migration
  def change
    add_column :details, :googfid, :string
  end
end
