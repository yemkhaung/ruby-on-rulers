require "rulers"

class HomeController < Rulers::Controller
    def index
        "Hello! You have arrived 'GET / HomeController'"
    end
end