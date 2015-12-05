class Guilt < ActiveRecord::Base
  belongs_to :company

  has_many :resources
end
