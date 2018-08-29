module Rulers
    class Application
        def get_controller_and_action(env)
            # split PATH for max four times 
            # as in [empty_string, controller, action, query-params]
            # empty_string is ignored by assigning to "_" underscore var
            _, cont, action, after = env["PATH_INFO"].split('/', 4)
            cont = cont.capitalize # e.g result => "People"
            cont +=  "Controller" # e.g result =>  "PeopleController"
            # "Object.const_get" look up class starting with CAP letter
            # thus return "PeopleController" class
            [Object.const_get(cont), action]
        end
    end
end