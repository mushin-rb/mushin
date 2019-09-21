module Mushin
  class Stack < Middleware::Builder
    def initialize &block 
      # let's use `super` to instance_eval inside Middleware::Builder scope
      super
      # Run it!
      call 
    end
  end
end
