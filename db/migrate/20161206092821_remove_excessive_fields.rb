class RemoveExcessiveFields < ActiveRecord::Migration
  
  def self.up
    remove_column :users,		:age,		:integer
    remove_column :users,		:phone,	:integer
  end

  def self.down
    add_column		:user,	:age, 	:integer, default: nil, null: true
    add_column		:user,	:phone, :integer, default: nil, null: true
  end

end
