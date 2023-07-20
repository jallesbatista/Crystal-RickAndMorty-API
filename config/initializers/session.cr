#!/usr/bin/env crystal
require "jennifer/adapter/postgres" # for PostgreSQL

require "db"
require "pg"

DB.open("postgres://jalles:1010@db:5432/codechallenge_db") do |db|
  puts "DATABASE OPEN"
end
