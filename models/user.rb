class User < ActiveRecord::Base
  belongs_to :office
  has_many :vacations
end
