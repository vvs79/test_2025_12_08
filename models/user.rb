class User < ApplicationRecord
  belongs_to :office
  has_many :vacations
end
