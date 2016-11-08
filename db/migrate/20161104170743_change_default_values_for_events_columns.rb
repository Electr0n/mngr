class ChangeDefaultValuesForEventsColumns < ActiveRecord::Migration
  def self.up
    change_column :events, :number, :integer, default: 194673, null: false
    change_column :events, :agemax, :integer, default: 194673, null: false
    change_column :events, :agemin, :integer, default: 0, null: false
  end
  def self.down
    change_column :events, :number, :integer, default: nil, null: true
    change_column :events, :agemax, :integer, default: nil, null: true
    change_column :events, :agemin, :integer, default: nil, null: true
  end
end
