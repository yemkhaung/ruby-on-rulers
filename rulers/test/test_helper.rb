require "rack/test"
require "test/unit"

# always use local rulers first
d = File.join(File.dirname(__FILE__), "..", "lib")
$LOAD_PATH.unshift File.expand_path(d)

require "rulers"
