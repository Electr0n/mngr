class Phone < ActiveRecord::Base

  belongs_to :user

  validates :number, :code, numericality: { only_integer: true, greater_than: 0 }
  validates :number,  length: { minimum: 3, maximum: 10 }
  validates :code,    length: { minimum: 1, maximum: 3 }
  validates :description,  length: { maximum: 50 }
  
end