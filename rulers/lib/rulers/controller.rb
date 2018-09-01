require "erubis"

module Rulers
    class Controller
        def initialize(env)
          @env = env
        end
        
        def env
          @env
        end

        def render(view_name, locals = {})
            file_name = File.join "app", "views", controller_name, "#{view_name}.html.erb"
            tempate = File.read file_name
            eruby = Erubis::Eruby.new(tempate)
            eruby.result locals.merge(:env => env)
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