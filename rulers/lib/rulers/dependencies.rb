class Object
    # Overrides Object.const_missing() which is invoked when Object.const_get()
    # cannot find the dependency reference.
    # Loads the dependency of Class e.g "QuotesController", 
    # where this fn will convert class name to "quotes_controller"
    def self.const_missing(c)
        return nil if @calling_const_missing
        @calling_const_missing = true
        require Rulers.to_underscore(c.to_s)
        klass = Object.const_get(c)
        @calling_const_missing = false
        klass
    end
end