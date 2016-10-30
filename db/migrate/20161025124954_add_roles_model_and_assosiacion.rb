class AddRolesModelAndAssosiacion < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string  :name
    end
    change_table :users do |t|
      t.remove :role
    end
    create_table :roles_users, id: false do |t|
      t.belongs_to  :user
      t.belongs_to  :role
    end
  end
end
