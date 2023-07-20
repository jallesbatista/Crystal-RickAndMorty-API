# TODO: Write documentation for `CodeChallenge`

require "kemal"
require "../config/config"
require "http/server"
require "http/client"
require "json"
require "./handlers/**"
require "http"

class HTTPVersionHandler < Kemal::Handler
  def call(context : HTTP::Server::Context)
    context.response.headers["HTTP_VERSION"] = "HTTP/1.1"
    super
  end
end

add_handler(HTTPVersionHandler.new)

module CodeChallenge
  VERSION = "0.1.0"

  # TODO: Put your code here

  before_all do |env|
    env.response.content_type = "application/json"
    env.response.headers["HTTP_VERSION"] = "HTTP/1.0"
  end

  get "/travel_plans" do |env|
    expand = env.params.query["expand"]?
    optimize = env.params.query["optmize"]?
    travels = Travel.all.order({:id => :asc})

    if (expand == "true" || expand) && (!optimize || optimize == "false")
      expandedData = [] of NamedTuple(id: Int64 | Nil, travel_stops: Array(NamedTuple(id: Int64, name: JSON::Any, type: JSON::Any, dimension: JSON::Any)))

      travels.each do |travel|
        stops = travel.travel_stops
        stops = stops.map do |stop|
          response = HTTP::Client.get("https://rickandmortyapi.com/api/location/#{stop}")
          body = JSON.parse(response.body)
          returnedStop = {
            "id":        stop,
            "name":      body["name"],
            "type":      body["type"],
            "dimension": body["dimension"],
          }
          returnedStop
        end
        expandedData << {
          "id":           travel.id,
          "travel_stops": stops,
        }

        puts typeof(expandedData)
      end

      halt env, status_code: 200, response: expandedData.to_json
    end

    if optimize == "true" || optimize
      optmizedTravels = [] of NamedTuple(id: Int64 | Nil, travel_stops: Array(Array(NamedTuple(id: Int64, name: JSON::Any, type: JSON::Any, dimension: JSON::Any)) | Int64 | NamedTuple(id: Int64, name: JSON::Any, dimension: JSON::Any)) | Array(Array(NamedTuple(id: Int64, name: JSON::Any, type: JSON::Any, dimension: JSON::Any)) | Int64) | Array(Array(NamedTuple(id: Int64, name: JSON::Any, type: JSON::Any, dimension: JSON::Any)) | NamedTuple(id: Int64, name: JSON::Any, dimension: JSON::Any)) | Array(Array(NamedTuple(id: Int64, name: JSON::Any, type: JSON::Any, dimension: JSON::Any))))
      travels.each do |travel|
        optmizedTravelStops = [] of Array(NamedTuple(id: Int64, name: JSON::Any, type: JSON::Any, dimension: JSON::Any))
        dimensions = [] of String
        dimensiosAvarage = [] of NamedTuple(dimension: String, media: (Float64 | String))
        data = [] of NamedTuple(id: Int64, name: JSON::Any, dimension: JSON::Any, value: Int32)
        stops = travel.travel_stops

        # BUSCAR CADA TRAVEL_STOP NA API
        stops.each do |stop|
          response = HTTP::Client.get("https://rickandmortyapi.com/api/location/#{stop}")
          body = JSON.parse(response.body)
          dimensions << body["dimension"].to_s unless dimensions.includes?(body["dimension"].to_s)
          data << {
            "id":        stop,
            "name":      body["name"],
            "dimension": body["dimension"],
            "value":     body["residents"].size,
          }
        end

        # LOOP PARA FAZER O OBJETO CONTENDO A DIMENSÃO E SUA MÉDIA POPULACIONAL
        dimensions.each do |dimension|
          sum = 0

          data.each do |data|
            if data["dimension"] == dimension
              sum += data["value"]
            end
          end

          dimensiosAvarage << {
            "dimension": dimension,
            "media":     sum / data.count { |el| el["dimension"].to_s == dimension },
          }
        end

        # ORDENAÇÃO PELA POPULAÇÃO MEDIA OU PELO NOME DA DIMENSÃO
        dimensiosAvarage = dimensiosAvarage.sort do |a, b|
          if a.["media"] != b.["media"]
            a.["media"].to_i64 <=> b.["media"].to_i64
          else
            a.["dimension"] <=> b.["dimension"] # Compara pela ordem alfabética
          end
        end

        # OTIMIZAÇÂO DOS DADOS
        dimensiosAvarage.each do |dimension|
          listToBeSorted = [] of NamedTuple(id: Int64, name: JSON::Any, dimension: JSON::Any, value: Int32)
          data.each do |el|
            if el["dimension"] == dimension["dimension"]
              listToBeSorted << el
            end
          end

          listToBeSorted = listToBeSorted.sort_by { |data| data["value"] }

          if expand == "true" || expand
            optmizedTravelStops = optmizedTravelStops + listToBeSorted.map do |data|
              {
                "id":        data["id"],
                "name":      data["name"],
                "dimension": data["dimension"],
              }
            end
          else
            optmizedTravelStops = optmizedTravelStops + listToBeSorted.map do |data|
              data["id"]
            end
          end
        end

        optmizedTravels << {
          "id":           travel.id,
          "travel_stops": optmizedTravelStops,
        }
      end

      halt env, status_code: 200, response: optmizedTravels.to_json
    end

    halt env, status_code: 200, response: travels.to_json
  end

  get "/travel_plans/:id" do |env|
    id = env.params.url["id"]

    travel = Travel.find!(id)

    halt env, status_code: 200, response: travel.to_json
  end

  post "/travel_plans" do |env|
    requestTravelList = env.params.json["travel_stops"]?.to_s

    testedRequestTravelList = Array(Int64).from_json(requestTravelList)

    travels = Travel.create({"travel_stops": testedRequestTravelList})

    halt env, status_code: 201, response: travels.to_json
  end

  put "/travel_plans/:id" do |env|
    id = env.params.url["id"]

    requestTravelList = env.params.json["travel_stops"]?.to_s

    findedTravel = Travel.find!(id)

    testedRequestTravelList = Array(Int64).from_json(requestTravelList)

    findedTravel.travel_stops = testedRequestTravelList
    findedTravel.save

    halt env, status_code: 200, response: findedTravel.to_json
  end

  delete "/travel_plans/:id" do |env|
    id = env.params.url["id"]

    findedTravel = Travel.find!(id)
    findedTravel.delete

    puts findedTravel

    halt env, status_code: 204, response: "No Content"
  end
end

Kemal.run(3000)
