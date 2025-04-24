module Api
  module V1
    class TransactionsController < ApplicationController
      include ResponseRendererConcern

      def single
        transaction = Transaction.new(transaction_params)
        if transaction.save
          render_success({ transaction_id: transaction.transaction_id })
        else
          render_error(transaction.errors.full_messages)
        end
      end

      def bulk
        transactions = params[:transactions].map do |tx|
          Transaction.new(tx.permit(:transaction_id, :points, :user_id))
        end

        Transaction.transaction do
          transactions.each(&:save!)
        end

        render_success({ processed_count: transactions.size })
      rescue ActiveRecord::RecordInvalid => e
        render_error(e.message)
      end

      private

      def transaction_params
        params.permit(:transaction_id, :points, :user_id)
      end
    end
  end
end
