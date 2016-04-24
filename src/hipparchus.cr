require "kemal"
require "json"
require "redis"
require "./hipparchus/google_maps_api.cr"

redis = Redis.new

get "/:address" do |env|
  address = env.params.url["address"].downcase
  env.response.content_type = "application/json"
  location = redis.get("coordinates:#{address}")

  if location
    response = { location: Hipparchus::GoogleMapsApi::Location.from_json(location) }
  else
    begin
      record = Hipparchus::GoogleMapsApi::Client.new.get(address)
      if !record.results.empty?
        location = record.results[0].geometry.location
      else
        location = Hipparchus::GoogleMapsApi::Location.from_json(%({"lat": 0.0, "lng": 0.0}))
      end
      redis.set("coordinates:#{address}", location.to_json)
      response = { location: location }
    rescue ex : Hipparchus::GoogleMapsApi::Client::ServerError
      response = { error: ex.message }
    end
  end

  response.to_json
end

Kemal.run
