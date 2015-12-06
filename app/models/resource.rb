class Resource < ActiveRecord::Base
  has_many :evidence
  has_many :guilt_resources
end
