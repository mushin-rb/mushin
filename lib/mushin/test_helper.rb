module Mushin
  module Test
    module Sample
      class Ext 
	using Mushin::Ext
	def initialize(ext, opts = {}, params= {})
	  @ext 		= ext 
	  @opts    	= opts 
	  @params  	= params 
	end

	def call(env)
	  env ||= Hash.new #if env.nil?
	  $log.info "-----------------------------------------------------------------------"
	  $log.info "Ext: #{self} is called with the following options: #{@opts} & params: #{@params}; and env: #{env}"
	  $log.info "-----------------------------------------------------------------------"

	  # Inbound maniuplation

	  env[:events] ||= []

	  $log.info  env[:var] = "#{self} new_value_inbound"

	  $log.info  env[:events] << "#{self} new_event_inbound"

	  @ext.call(env)

	  #Outbound maniuplation
	  $log.info  env[:var] = "#{self} new_value_outbound"

	  $log.info env[:events] << "#{self} new_event_outbound"
	end
      end
    end
  end
end
