class User < ApplicationRecord
  validates :name, presence: true
  validates :token, presence: true
end
