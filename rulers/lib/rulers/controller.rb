require "erubis"

module Rulers
    class Controller
        def initialize(env)
          @env = env
        end
        
        def env
          @env
        end

        def request
            # ||= means : 
            # use old request if not nil or false (OR) create a new one 
            @request ||= Rack::Request.new(@env)
        end

        def params
            request.params
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