require "rulers/version"
require "rulers/routing"
require "rulers/utils"
require "rulers/dependencies"

module Rulers
  
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      elsif env['PATH_INFO'] == '/'
        # Redirect to /home/index (HomeController#index)
        return [302, {'Location' => "http://#{env['HTTP_HOST']}/home/index"}, []]
      end
      
      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      begin
        text = controller.send(act)
      rescue
        return [500, {'Content-Type' => 'text/html'}, ["Invoking controller's action is failed"]]
      end
      [200, {'Content-Type' => 'text/html'}, [text]]
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end
    def env
      @env
    end
  end
end
