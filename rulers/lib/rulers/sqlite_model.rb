require "sqlite3"
require "rulers/utils"

DB = SQLite3::Database.new "quotesdata.db"

module Rulers
    module Model
        class SQLiteModel

            # create table quotes (
            #   id integer primary key autoincrement,
            #   submitter varchar(15),
            #   quote varchar(50),
            #   attribution varchar(15)
            # );
            def self.table
                Rulers.to_underscore "quotes"
            end

            # creates and returns schema
            # in {column_name: column_type}, key-value pairs
            def self.schema
                return @schema if @schema
                @schema = {}
                DB.table_info(table) do |row|
                    @schema[row["name"]] = row["type"]
                end
                @schema
            end

            def initialize(data = nil)
                @hash = data
            end

            # converts any value into SQL compatible String format
            def self.to_sql(val)
                case val
                when Numeric
                    val.to_s
                when String
                    "'#{val}'"
                else
                    raise "Can't change #{val.class} to SQL!"
                end
            end

            def self.create(values)
                values.delete "id"
                # delete "id" entry from "schema" array
                #  Yes. Arrays can be substracted in ruby :3
                keys = schema.keys - ["id"]
                vals = keys.map do |key|
                    values[key] ? to_sql(values[key]) : "null"
                end
                DB.execute <<SQL
INSERT INTO #{table} (#{keys.join ","})
    VALUES (#{vals.join ","});
SQL
                # zip "keys" and "vals" into a hash
                #   Zip is convenient way to iterate arrays 
                #   and create key-value pairs by mapping values
                #   on same indexes
                data = Hash[keys.zip vals]
                sql = "SELECT last_insert_rowid();"
                data["id"] = DB.execute(sql)[0][0]
                puts "id >>> #{data["id"]}"
                self.new data
            end

            def self.count
                DB.execute(<<SQL)[0][0]
SELECT COUNT(*) FROM #{table};
SQL
            end

            def self.find(id)
                row = DB.execute <<SQL
SELECT #{schema.keys.join ","} FROM #{table}
WHERE id = #{id};
SQL
                data = Hash[schema.keys.zip row[0]]
                self.new data
            end

            def self.all
                rows = DB.execute <<SQL
SELECT #{schema.keys.join ","} FROM #{table};
SQL
                rows.map do |row|
                    data = Hash[schema.keys.zip row]
                    self.new data
                end
            end

            def [](name)
                @hash[name.to_s]
            end

            def []=(name, value)
                @hash[name.to_s] = value
            end

            # updates to existing model (dangerous version)
            #  returns exception if failed (!bang method)
            def save!
                unless @hash["id"]
                    self.class.create
                    return true
                end

                fields = @hash.map do |k, v|
                    "#{k}=#{self.class.to_sql(v)}"
                end.join ","

                DB.execute <<SQL
UPDATE #{self.class.table}
SET #{fields}
WHERE id = #{@hash["id"]}
SQL
                true
            end

            # updates to existing model
            #  returns false if failed
            def save
                self.save! rescue false
            end
        end
    end
end