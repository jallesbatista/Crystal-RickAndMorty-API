class EnsureIdIsValid < BaseHandler
  only ["/travel_plans/:id"], "PUT"
  only ["/travel_plans/:id"], "DELETE"
  only ["/travel_plans/:id"], "GET"

  def call(env)
    env.response.content_type = "application/json"
    env.response.headers["HTTP_VERSION"] = "HTTP/1.0"

    return call_next(env) unless only_match?(env)

    id = env.params.url["id"]

    begin
      id = id.to_i64
    rescue ArgumentError
      error = {message: "Id param must be an integer"}.to_json

      send(env, 400, error)
    end

    begin
      Travel.find!(id)
    rescue Jennifer::RecordNotFound
      error = {message: "Travel plan not found"}.to_json
      send(env, 404, error)
    end

    call_next(env)
  end
end

add_handler(EnsureIdIsValid.new)
