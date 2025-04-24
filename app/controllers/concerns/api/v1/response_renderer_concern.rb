module Api
  module V1
    module ResponseRendererConcern
      def render_success(data)
        # Response definition can be found on app/models/api/v1/response.rb,
        # we need a way to standardized response object to be in uniform
        # for all and upcoming API's
        render json: Response.new(status: "success", data:).as_json
      end

      # It's also a good thing to make the http status
      # parameter optional to have more flexibility to the caller
      def render_error(message:, http_status: :unprocessable_entity)
        render json: Response.new(status: "error", message:), status: http_status
      end
    end
  end
end
