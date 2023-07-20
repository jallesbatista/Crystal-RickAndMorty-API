require "kemal"
require "../models/*"

class BaseHandler < Kemal::Handler
  def send(env : HTTP::Server::Context, status_code = 200, response = "")
    env.response.status_code = status_code
    env.response.content_type = "application/json"
    env.response.headers["HTTP_VERSION"] = "HTTP/1.0"
    env.response.print response
    env.response.close
  end
end
