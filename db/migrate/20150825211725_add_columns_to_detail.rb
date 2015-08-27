class AddColumnsToDetail < ActiveRecord::Migration
  def change
    add_column :details, :s1, :string
    add_column :details, :s2, :string
    add_column :details, :s3, :string
  end
end
