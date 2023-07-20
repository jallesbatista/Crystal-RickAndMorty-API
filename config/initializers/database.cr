require "jennifer"
require "jennifer/adapter/postgres" # for PostgreSQL
require "pg"

APP_ENV = ENV["APP_ENV"]? || "development"

Jennifer::Config.from_uri("postgres://jalles:1010@db:5432/codechallenge_db")

Jennifer::Config.configure do |conf|
  conf.logger = Log.for("db", :debug)
end

Log.setup "db", :debug, Log::IOBackend.new(formatter: Jennifer::Adapter::DBFormatter)
