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

use BenchMarker
run BestQuotes::Application.new

# run Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }
# run proc { ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }
# run ->(env) { [200, {"Content-Type" => "text/html"}, ["Hello World!"]] }