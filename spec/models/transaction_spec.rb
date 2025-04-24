require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should validate_presence_of(:transaction_id) }
  it { should validate_presence_of(:points) }
  it { should validate_presence_of(:user_id) }
  it { should validate_uniqueness_of(:transaction_id) }
end
