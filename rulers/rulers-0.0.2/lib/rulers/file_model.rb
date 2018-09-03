require "multi_json"
module Rulers
    # data is stored as files
    module Model
        class FileModel
            def initialize(filename)
                @filename = filename
                # If filename: dir/23.json, then id: 23
                @id = File.split(filename, ".json").to_i

                obj = File.read(filename)
                @hash = MultiJson.decode(obj)
            end

            # getter method
            def [](name)
                @hash[name.to_s]
            end

            # setter method
            def []=(name, value)
                @hash[name.to_s] = value
            end

            def self.find(id)
                begin
                    FileModel.new("db/quotes/#{id}.json")
                rescue
                    return nil
                end
            end

            def self.all
                files = Dir["db/quotes/*.json"]
                files.map { |f| File.read f }
            end

            def self.create(attrs)
                # create a hash to store data attributes
                hash = {}
                hash["submitter"] = attrs["submitter"] || ""
                hash["quote"] = attrs["quote"] || ""
                hash["attribution"] = attrs["attribution"] || ""

                # generate ID (latestId + 1)
                files = Dir["db/quotes/*.json"]
                names = files.map { |f| f.split("/")[-1] }
                highest = names.map { |b| b[0...-5].to_i }.max
                id = highest + 1

                # Create a new data file
                File.open("db/quotes/#{id}.json", "w") do |f|
                    f.write <<TEMPLATE
{
    "submitter": "#{hash["submitter"]}",
    "quote": "#{hash["quote"]}",
    "attribution": "#{hash["attribution"]}"
}
TEMPLATE
                end
                FileModel.new "db/quotes/#{id}.json"
            end
        end
    end
end