module Api
  module V1
    class Response
      attr_accessor :status, :message, :data

      def initialize(status:, message: nil, data: {})
        @status  = status
        @message = message
        @data    = data
      end

      # Trim nil values from
      # the hash object
      def as_json
        {
          status:, message:
        }.merge(data).compact
      end
    end
  end
end
