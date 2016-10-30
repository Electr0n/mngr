class AddDeleteFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users,  :del_flag, :boolean, null: false, default: false
    add_column :events, :del_flag, :boolean, null: false, default: false
    add_index  :users,  :del_flag
    add_index  :events, :del_flag
  end
end
