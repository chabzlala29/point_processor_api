require 'rails_helper'

RSpec.describe "Transactions API", type: :request do
  describe "POST /api/v1/transactions/single" do
    context "with valid parameters" do
      it "creates a single transaction and returns success" do
        post "/api/v1/transactions/single", params: {
          transaction_id: "tx1",
          points: 100,
          user_id: "user1"
        }

        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json).to include("status" => "success", "transaction_id" => "tx1")
        expect(Transaction.find_by(transaction_id: "tx1")).not_to be_nil
      end
    end

    context "with missing parameters" do
      it "returns an error response" do
        post "/api/v1/transactions/single", params: {
          points: 100,
          user_id: "user1"
        }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
        expect(json["message"]).to include("Transaction can't be blank")
      end
    end

    context "with duplicate transaction_id" do
      before do
        Transaction.create!(transaction_id: "tx1", points: 100, user_id: "user1")
      end

      it "returns an error for duplicate transaction_id" do
        post "/api/v1/transactions/single", params: {
          transaction_id: "tx1",
          points: 150,
          user_id: "user2"
        }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
        expect(json["message"]&.join).to include("Transaction has already been taken")
      end
    end
  end

  describe "POST /api/v1/transactions/bulk" do
    context "with valid transactions" do
      let(:valid_transactions) do
        [
          { transaction_id: "tx2", points: 200, user_id: "user2" },
          { transaction_id: "tx3", points: 300, user_id: "user3" }
        ]
      end

      it "creates all transactions and returns success" do
        post "/api/v1/transactions/bulk", params: { transactions: valid_transactions }

        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json).to include("status" => "success", "processed_count" => 2)
        expect(Transaction.find_by(transaction_id: "tx2")).not_to be_nil
        expect(Transaction.find_by(transaction_id: "tx3")).not_to be_nil
      end
    end

    context "when one of the transactions is invalid" do
      let(:invalid_transactions) do
        [
          { transaction_id: "tx4", points: 100, user_id: "user4" },
          { points: 200, user_id: "user5" } # Missing transaction_id
        ]
      end

      it "does not create any transactions and returns an error" do
        post "/api/v1/transactions/bulk", params: { transactions: invalid_transactions }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
        expect(Transaction.find_by(user_id: "user4")).to be_nil
        expect(Transaction.find_by(user_id: "user5")).to be_nil
      end
    end

    context "with empty transaction list" do
      it "returns success with processed_count 0" do
        post "/api/v1/transactions/bulk", params: { transactions: [] }

        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json).to include("status" => "success", "processed_count" => 0)
      end
    end
  end
end
