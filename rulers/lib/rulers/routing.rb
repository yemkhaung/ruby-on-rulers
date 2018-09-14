class RouteObject
    def initialize
       @rules = [] 
    end

    def match(url, *args)
        # extract if routing options hash exists
        options = {}
        options = args.pop if args[-1].is_a?(Hash)
        options[:default] ||= {}

        # if routing options is a string format 
        # i.e "quotes#index" OR a proc
        dest = nil
        dest ||= args.pop if args.size > 0
        raise "Too many arguments!" if args.size > 0

        # extract URI variables from URL 
        # and constructs regexp pattern for matching
        parts = url.split("/")
        parts.select! { |p| !p.empty? }

        vars = [] # URI variabless (controller, action, ...etc)
        regexp_parts = parts.map do |part|
            if part[0] == ":"
                vars << part[1..-1]
                "([a-zA-Z0-9_]+)"
            elsif part[0] == "*"
                vars << part[1..-1]
                "(.*)"
            else
                part
            end 
        end

        regexp = regexp_parts.join("/")
        @rules.push({
            :regexp => Regexp.new("^/#{regexp}$"),
            :vars => vars,
            :dest => dest,
            :options => options,
        })
    end

    def check_url(url)
        STDERR.puts "@RULES >>> ", @rules
        @rules.each do |r|
            # check if there is any matches
            m = r[:regexp].match(url)
            if m
                options = r[:options]
                params = options[:default].dup
                # matches up variable names with parts captured by regexp
                r[:vars].each_with_index do |v,i|
                    params[v] = m.captures[i]
                end
                dest = nil
                
                if r[:dest]
                    return get_dest(r[:dest], params)
                else
                    # get :controller and :action variables 
                    controller = params["controller"]
                    action = params["action"]
                    return get_dest("#{controller}" + "##{action}", params)
                end
            end
        end
        nil
    end

    # Converts :destination into a Rack App
    def get_dest(dest, routing_params = {})
        # if :dest has a #call method (i.e :dest a proc)
        return dest if dest.respond_to?(:call)
        # otherwise split up with "#" and look up :controller and :action
        if dest =~ /^([^#]+)#([^#]+)$/
            name = $1.capitalize
            cont = Object.const_get("#{name}Controller")
            return cont.action($2, routing_params)
        end
        raise "No destination: #{dest.inspect}!"
    end
end

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