class Transaction < ApplicationRecord
  validates :transaction_id, :points, :user_id, presence: true
  validates :transaction_id, uniqueness: true
end
