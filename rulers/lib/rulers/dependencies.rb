class Object
    # Overrides Object.const_missing() which is invoked when Object.const_get()
    # cannot find the dependency reference.
    # Loads the dependency of Class e.g "QuotesController", 
    # where this fn will convert class name to "quotes_controller"
    def self.const_missing(c)
        require Rulers.to_underscore(c.to_s)
        Object.const_get(c)
    end
end