class AddFieldsToUser < ActiveRecord::Migration
  def self.up
  	add_column		:users, :name, 		:string
  	add_column		:users, :surname, 	:string
  	add_column		:users, :bday, 		:date
  	add_column		:users, :gender, 	:string
  	add_column		:users, :age,		:integer
  	add_column		:users, :phone, 	:integer
  	add_column		:users, :country, 	:string
  	add_column		:users, :city, 		:string
  	add_column		:users, :hobby,		:string
  	add_column		:users, :about, 	:string
  	add_column		:users, :role, 		:string,	null: false, default: "user"
  	add_column		:users, :denied_t, 	:integer
  	add_column		:users, :locked,	:boolean,	null: false, default: false

  	add_index 		:users, :name
  	add_index 		:users, :surname
  	add_index 		:users, :bday
  	add_index 		:users, :gender
  	add_index 		:users, :age
  	add_index 		:users, :country
  	add_index 		:users, :city
  	add_index 		:users, :hobby
  	add_index 		:users, :role
  	add_index 		:users, :denied_t
  	add_index 		:users, :locked
  end

  def self.down
  	remove_column		:users, :name, 		:string
  	remove_column		:users, :surname, 	:string
  	remove_column		:users, :bday, 		:date
  	remove_column		:users, :gender, 	:string
  	remove_column		:users, :age,		:integer
  	remove_column		:users, :phone, 	:integer
  	remove_column		:users, :country, 	:string
  	remove_column		:users, :city, 		:string
  	remove_column		:users, :hobby,		:string
  	remove_column		:users, :about, 	:string
  	remove_column		:users, :role, 		:string
  	remove_column		:users, :denied_t, 	:integer
  	remove_column		:users, :locked,	:boolean
  end
end
