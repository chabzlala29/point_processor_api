class Api::V1::TransactionsController < ApplicationController
  def single
    transaction = Transaction.new(transaction_params)

    if transaction.save
      render json: { status: "success", transaction_id: transaction.transaction_id }
    else
      render json: { status: "error", errors: transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def bulk
    transactions = params[:transactions].map do |tx|
      Transaction.new(tx.permit(:transaction_id, :points, :user_id))
    end

    Transaction.transaction do
      transactions.each(&:save!)
    end

    render json: { status: "success", processed_count: transactions.size }
  rescue ActiveRecord::RecordInvalid => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  private

  def transaction_params
    params.permit(:transaction_id, :points, :user_id)
  end
end
