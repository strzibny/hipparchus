require "http/client"
require "json"

module Hipparchus
  module GoogleMapsApi
    class Client
      class ServerError < Exception; end
      Host = "maps.googleapis.com"

      def initialize(http_client : HTTP::Client = HTTP::Client.new(Host, ssl: true))
        @http_client = http_client
      end

      def get(location : String)
        response = @http_client.get("/maps/api/geocode/json?address=#{location}")
        process_response(response)
      end

      private def process_response(response : HTTP::Client::Response)
        case response.status_code
        when 200..299
          # For cases when "status" is one of the following:
          #   ZERO_RESULTS
          #   OK
          return SuccessResponse.from_json(response.body) \
            if ["OK", "ZERO_RESULTS"].includes?(Response.from_json(response.body).status)

          # For cases when "status" is one of the following:
          #   OVER_QUERY_LIMIT
          #   REQUEST_DENIED
          #   INVALID_REQUEST
          raise Client::ServerError.new(ErrorResponse.from_json(response.body).error_message)
        when 400
          raise Client::ServerError.new("400: Server Not Found")
        when 500
          raise Client::ServerError.new("500: Internal Server Error")
        when 502
          raise Client::ServerError.new("502: Bad Gateway")
        when 503
          raise Client::ServerError.new("503: Service Unavailable")
        when 504
          raise Client::ServerError.new("504: Gateway Timeout")
        else
          raise Client::ServerError.new("Server returned error #{response.status_code}")
        end
      end
    end

    class Location
      JSON.mapping({
        lat: Float64,
        lng: Float64,
      })
    end

    class Geometry
      JSON.mapping({
        location: Location
      })
    end

    class Result
      JSON.mapping({
        geometry: Geometry
      })
    end

    class Response
      JSON.mapping({
        status: String
      })
    end

    class SuccessResponse
      JSON.mapping({
        results: Array(Result),
        status: String
      })
    end

    class ErrorResponse
      JSON.mapping({
        error_message: String,
        status: String
      })
    end
  end
end
