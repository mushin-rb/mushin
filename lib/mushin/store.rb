module Mushin
  #TODO maybe use refinements instead of inheritance for `using Mushin::Ext`
  class Store < Mushin::Test::Sample::Ext
    def initialize(ext, opts = {}, params= {})
      @ext 	= ext 
      @opts    	= opts 
      @params  	= params 
    end

    def call(env)
      env ||= Hash.new 
      @ext.call(env)
      return env
    end
  end
end
