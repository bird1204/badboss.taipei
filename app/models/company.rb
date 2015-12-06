class Company < ActiveRecord::Base
  has_many :alias
  has_many :score
  has_many :guilt
end
