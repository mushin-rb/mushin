module Mushin
  module Ext
    refine Class do 
      def initialize app
	raise NotImplementedError, "Mushin Extenstions implement :initialize that takes an app"
      end 
      def call env
	raise NotImplementedError, "Mushin Extenstions implement :call that takes an env"
      end 
    end
  end
end
