require "rulers"

$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "controllers")
require "home_controller"
require "quotes_controller"

module BestQuotes
    class Application < Rulers::Application
    end
end