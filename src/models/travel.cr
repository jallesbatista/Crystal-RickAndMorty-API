class Travel < Jennifer::Model::Base
  mapping(
    id: Primary64,
    travel_stops: {type: Array(Int64)}
  )
end
