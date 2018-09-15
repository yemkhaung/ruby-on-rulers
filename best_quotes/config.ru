require './config/application'

# BenchMarker
#  benchmarking middleware
#
class BenchMarker
    def initialize(app)
        @app = app
    end

    def call(env)
        start = Time.now
        
        result = nil
        result = @app.call(env)
        duration = Time.now - start

        STDERR.puts <<OUTPUT
Benchmark:
    #{duration.to_f} seconds total
OUTPUT
        result
    end
end

app = BestQuotes::Application.new

use Rack::ContentType

# Setup Routes
app.route do
    match "", "quotes#index"
    match "subapp",
        proc { [200, {}, ["Hello, Sub App!"]] }
    #default routes
    match ":controller/:action/:id"
    match ":controller/:action"
    match ":controller",
        :default => { "action" => "index" }
end

use BenchMarker
run app

# run Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }
# run proc { ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }
# run ->(env) { [200, {"Content-Type" => "text/html"}, ["Hello World!"]] }