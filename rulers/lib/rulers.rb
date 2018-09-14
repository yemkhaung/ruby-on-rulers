require "rulers/version"
require "rulers/routing"
require "rulers/utils"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"
require "rulers/sqlite_model"

module Rulers
  
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end
      
      # spawn and call a Rack App from request
      rack_app = get_rack_app(env)
      raise "Route <#{env['PATH_INFO']}> not found!" unless rack_app
      rack_app.call(env)
    end

    def route(&block)
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval(&block)
    end

    def get_rack_app(env)
      raise "No Route!" unless @route_obj
      @route_obj.check_url env['PATH_INFO']
    end
  end
end
