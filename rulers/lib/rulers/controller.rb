require "erubis"
require "rulers/file_model"
require "rulers/sqlite_model"

module Rulers
    class Controller
        include Rulers::Model
        def initialize(env)
          @env = env
          @routing_params = {}
        end

        def dispatch(action, routing_params = {})
            @routing_params = routing_params
            text = self.send(action)
            if get_response
                resp = get_response
                [resp.status, resp.headers, resp.body]
            else
                [200, {'Content-Type' => 'text/html'}, [text]]
            end
        end

        def self.action(act, rp)
            proc { |e| self.new(e).dispatch(act, rp) }
        end


        def params
            request.params.merge @routing_params
        end

        def env
          @env
        end

        def request
            # ||= means : 
            # use old request if not nil or false (OR) create a new one 
            @request ||= Rack::Request.new(@env)
        end

        def response(text, status=200, headers = {'Content-Type' => 'text/html'})
            raise "Already responded!" if @response
            @response = Rack::Response.new(text, status, headers)
        end

        def get_response
            @response
        end

        def render_response(*args)
            response(render(*args))
        end

        def render(view_name, locals = {})
            file_name = File.join "app", "views", controller_name, "#{view_name}.html.erb"
            raise "TEMPLATE NOT FOUND" unless File.exist? file_name
            tempate = File.read file_name
            eruby = Erubis::Eruby.new(tempate)
            model = locals.merge(:env => env)
            eruby.result model
        end

        def controller_name
            # get the class of current self
            klass = self.class
            # delete "Controller" part in controller name
            klass = klass.to_s.gsub /Controller$/, "" # Quote
            Rulers.to_underscore klass # quote
        end

    end
end