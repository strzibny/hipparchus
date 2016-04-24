require "spec"
require "mocks/spec"
require "http/client"

module SpecHelper
  module GoogleMapsApi
    extend self

    def successful_response
      HTTP::Client::Response.new(
        200,
        %(
          {
            "results" : [
              {
                "address_components" : [
                  {
                    "long_name" : "Opava",
                    "short_name" : "Opava",
                    "types" : [ "locality", "political" ]
                  },
                  {
                     "long_name" : "Opava District",
                     "short_name" : "Opava District",
                     "types" : [ "administrative_area_level_2", "political" ]
                  },
                  {
                     "long_name" : "Moravian-Silesian Region",
                     "short_name" : "Moravian-Silesian Region",
                     "types" : [ "administrative_area_level_1", "political" ]
                  },
                  {
                     "long_name" : "Czech Republic",
                     "short_name" : "CZ",
                     "types" : [ "country", "political" ]
                  }
                ],
                "formatted_address" : "Opava, Czech Republic",
                "geometry" : {
                  "bounds" : {
                    "northeast" : {
                      "lat" : 49.9939829,
                      "lng" : 17.9964488
                    },
                    "southwest" : {
                      "lat" : 49.8477767,
                      "lng" : 17.7905329
                    }
                  },
                  "location" : {
                    "lat" : 49.9406598,
                    "lng" : 17.8947989
                  },
                  "location_type" : "APPROXIMATE",
                  "viewport" : {
                    "northeast" : {
                      "lat" : 49.9939829,
                      "lng" : 17.9964488
                    },
                    "southwest" : {
                      "lat" : 49.8477767,
                      "lng" : 17.7905329
                    }
                  }
                },
                "place_id" : "ChIJm8CGORPYE0cRvzf4rjv_0RQ",
                "types" : [ "locality", "political" ]
              }
            ],
            "status" : "OK"
          }
        )
      )
    end

    def zero_results_response
      HTTP::Client::Response.new(
        200,
        %(
          {
             "results" : [],
             "status" : "ZERO_RESULTS"
          }
        )
      )
    end

    def error_response
      HTTP::Client::Response.new(
        200,
        %(
          {
            "error_message" : "You have exceeded your daily request quota for this API. We recommend registering for a key at the Google Developers Console: https://console.developers.google.com/apis/credentials?project=_",
            "results" : [],
            "status" : "OVER_QUERY_LIMIT"
          }
        )
      )
    end
  end
end
