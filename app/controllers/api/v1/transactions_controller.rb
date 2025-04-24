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
          render_error(message: transaction.errors.full_messages)
        end
      end

      def bulk
        # When submitting empty array from client request,
        # it might receive a one element array with empty string,
        # so having a pre-emptive select for presence is needed to avoid
        # fetching unwanted transaction object.
        transactions = params[:transactions].select(&:presence).map do |transaction|
          Transaction.new(transaction.permit(WRITE_PERMITTED_PARAMS))
        end

        Transaction.transaction do
          transactions.each(&:save!)
        end

        render_success({ processed_count: transactions.size })
      rescue ActiveRecord::RecordInvalid => e
        render_error(message: e.message)
      end

      private

      def transaction_params
        params.permit(WRITE_PERMITTED_PARAMS)
      end
    end
  end
end
