require './config/application'

run BestQuotes::Application.new

# run Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }
# run proc { ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }
# run ->(env) { [200, {"Content-Type" => "text/html"}, ["Hello World!"]] }