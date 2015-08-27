class AddColumn2ToDetail < ActiveRecord::Migration
  def change
    add_column :details, :googfid2, :string
  end
end
