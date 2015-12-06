class Company < ActiveRecord::Base
  has_many :alias
  has_many :scores
  has_many :guilts
  accepts_nested_attributes_for :guilts
end
