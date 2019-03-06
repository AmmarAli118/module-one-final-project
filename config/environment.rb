require "bundler"
Bundler.require
require_all "lib"
db_connection = ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "db/development.db")
## Start console with "ActiveRecord::Base.logger.level= 1"
