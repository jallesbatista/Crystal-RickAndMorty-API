class EnsureDataIsValidHandler < BaseHandler
  only ["/travel_plans/:id"], "PUT"
  only ["/travel_plans"], "POST"

  def call(env)
    env.response.content_type = "application/json"
    env.response.headers["HTTP_VERSION"] = "HTTP/1.0"

    return call_next(env) unless only_match?(env)

    requestTravelList = env.params.json["travel_stops"]?.to_s

    if requestTravelList.size == 0
      error = {message: "travel_stops required"}.to_json
      send(env, 400, error)
    end

    begin
      testedRequestTravelList = Array(Int64).from_json(requestTravelList)
      testedRequestTravelList.each do |travel|
        response = HTTP::Client.get("https://rickandmortyapi.com/api/location/#{travel}")
        if response.status_code >= 400
          error = {message: "Location with id #{travel} was not found"}.to_json
          send(env, 400, error)
        end
      end
    rescue JSON::ParseException
      error = {message: "Must be a array of integers"}.to_json
      send(env, 400, error)
    end

    call_next(env)
  end
end

add_handler(EnsureDataIsValidHandler.new)
