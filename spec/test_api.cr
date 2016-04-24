require "./spec_helper"
require "../src/hipparchus/google_maps_api.cr"

Mocks.create_mock HTTP::Client do
  mock instance.get(url)
end

describe Hipparchus::GoogleMapsApi do
  describe "geocoding" do
    it "correctly parses a successful response" do
      http_client = ::HTTP::Client.new(Hipparchus::GoogleMapsApi::Client::Host)
      allow(http_client)
        .to receive(get("/maps/api/geocode/json?address=Opava"))
        .and_return(SpecHelper::GoogleMapsApi.successful_response)
      Hipparchus::GoogleMapsApi::Client.new(http_client)
        .get("Opava")
        .results[0]
        .geometry
        .location
        .lat
        .should eq Float64.new("49.9406598")
      Hipparchus::GoogleMapsApi::Client.new(http_client)
        .get("Opava")
        .results[0]
        .geometry
        .location
        .lng
        .should eq Float64.new("17.8947989")
    end

    it "correctly parses a zero results response" do
      http_client = ::HTTP::Client.new(Hipparchus::GoogleMapsApi::Client::Host)
      allow(http_client)
        .to receive(get("/maps/api/geocode/json?address=Opava"))
        .and_return(SpecHelper::GoogleMapsApi.zero_results_response)
      Hipparchus::GoogleMapsApi::Client.new(http_client)
        .get("Opava")
        .results
        .should eq [] of Hipparchus::GoogleMapsApi::Result
    end

    it "correctly parses an error response" do
      http_client = ::HTTP::Client.new(Hipparchus::GoogleMapsApi::Client::Host)
      allow(http_client)
        .to receive(get("/maps/api/geocode/json?address=Opava"))
        .and_return(SpecHelper::GoogleMapsApi.error_response)

      expect_raises(Hipparchus::GoogleMapsApi::Client::ServerError) do
        Hipparchus::GoogleMapsApi::Client.new(http_client).get("Opava")
      end
    end
  end
end
