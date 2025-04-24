module Api
  module V1
    class TransactionsController < ApplicationController
      include ResponseRendererConcern

      WRITE_PERMITTED_PARAMS = %i[transaction_id points user_id].freeze

      def single
        transaction = Transaction.new(transaction_params)

        if transaction.save
          render_success({ transaction_id: transaction.transaction_id })
        else
          render_error(transaction.errors.full_messages)
        end
      end

      def bulk
        transactions = params[:transactions].map do |transaction|
          Transaction.new(transaction.permit(WRITE_PERMITTED_PARAMS))
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
        params.permit(WRITE_PERMITTED_PARAMS)
      end
    end
  end
end
