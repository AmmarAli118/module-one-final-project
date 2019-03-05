require "bundler"
require_all "lib"
Bundler.require

db_connection = ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "db/development.db")
db_connection.logger = nil
