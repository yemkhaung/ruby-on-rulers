require "rulers/version"
require "rulers/routing"
require "rulers/utils"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"

module Rulers
  
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      elsif env['PATH_INFO'] == '/'
        # Redirect to /home/index (HomeController#index)
        return [302, {'Location' => "http://#{env['HTTP_HOST']}/home/index"}, []]
      end
      
      # Load the controller and execute the controller's action
      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(act)
      # response with text returned from controller action
      [200, {'Content-Type' => 'text/html'}, [text]]
    end
  end
end
