require 'rails_helper'

RSpec.describe "Transactions API", type: :request do
  describe "POST /api/v1/transactions/single" do
    it "creates a single transaction" do
      post "/api/v1/transactions/single", params: {
        transaction_id: "tx1",
        points: 100,
        user_id: "user1"
      }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include("status" => "success", "transaction_id" => "tx1")
    end
  end

  describe "POST /api/v1/transactions/bulk" do
    it "creates multiple transactions" do
      post "/api/v1/transactions/bulk", params: {
        transactions: [
          { transaction_id: "tx2", points: 200, user_id: "user2" },
          { transaction_id: "tx3", points: 300, user_id: "user3" }
        ]
      }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include("status" => "success", "processed_count" => 2)
    end
  end
end
