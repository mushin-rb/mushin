require 'set'
#TODO write fucken tests, move old specs to hacks dir, then select one big good spec
#TODO write a good generator!
#TODO release 1.0rc

module Mushin
  module Domain

    refine Class do 
      #TODO apply advanced centerlized logging automatically via TracePoint, DEBUG log level, to save space of the other logging and make it more standarized style
      #trace = TracePoint.new(:c_call) do |tp| #  p [tp.lineno, tp.defined_class, tp.method_id, tp.event]#end#trace.enable
      @@dsl_tree = Set.new
      def context keyword, &context_block
	@context_keyword 		= keyword
	@context_hash 			= Hash.new
	@context_hash[@context_keyword] = []
	def construct keyword, &construct_block
	  @construct_keyword 			= keyword
	  @construct_hash 			= Hash.new
	  @construct_hash[@construct_keyword] 	= []
	  def use ext: nil, opts: nil, params: nil
	    $log.debug "use #{ext}, #{opts}, #{params}"
	    @construct_hash[@construct_keyword]  << {ext: ext, opts: opts, params: params}
	    #NOTE defining Domain instance methods in this class_exec block
	    class_exec do 
	      def store data_key: nil, data_value: nil
		if !data_key.nil? && !data_value.nil? then
		  @data[data_key] = data_value
		  return @data
		else
		  return @data
		end
	      end
	      def initialize &domain_block
		@data = Hash.new 
		#NOTE CQRS 
		@@dsl_tree.each do |klass_context_set|
		  klass_context_set.each do |klass_context_key, klass_context_value|
		    self.singleton_class.__send__ :define_method, klass_context_key do |&context_block|
		      klass_context_value.each do |klass_construct_set|
			$log.debug "the whole construct_set: #{klass_construct_set}"
			klass_construct_set.each do |klass_construct_key, klass_construct_value|
			  $log.debug "klass_construct_key #{klass_construct_key} | klass_construct_value #{klass_construct_value}"
			  $log.debug "#{@@dsl_tree}"
			  #NOTE creates an instance method with the name of the klass_construct_key
			  self.singleton_class.__send__ :define_method, klass_construct_key do |instance_hash = Hash.new|
			    @stack 		= Mushin::Stack.new
			    klass_construct_value.each do |klass_ext|
			      ext_hash 		= Hash.new
			      ext_hash[:ext] 	= klass_ext[:ext]
			      ext_hash[:params] = Hash.new
			      ext_hash[:opts] 	= Hash.new
			      klass_opts_hash 	= klass_ext[:opts]
			      klass_params_hash = klass_ext[:params]

			      if klass_context_key == "query" then
				ext_hash[:opts][:cqrs] = :cqrs_query
			      else
				ext_hash[:opts][:cqrs] = :cqrs_command
			      end

			      #NOTE provides an ext_hash via binding of instance_hash values to klass_hashs(opts & params) keys 
			      instance_hash.each do |instance_hash_key, instance_hash_value|
				ext_hash[:opts][klass_opts_hash.invert[instance_hash_key]] 	= instance_hash_value unless klass_opts_hash.nil? || klass_opts_hash.invert[instance_hash_key].nil? 
				ext_hash[:params][klass_params_hash.invert[instance_hash_key]] 	= instance_hash_value unless klass_params_hash.nil? || klass_params_hash.invert[instance_hash_key].nil? 
			      end

			      #NOTE adds the extras from klass_hashs via reverse merge
			      ext_hash[:opts] 	= klass_opts_hash.merge(ext_hash[:opts]) unless klass_opts_hash.nil?
			      ext_hash[:params] = klass_params_hash.merge(ext_hash[:params]) unless klass_params_hash.nil?


			      $log.debug "insert_before 0 into stack: #{ext_hash[:ext]}, #{ext_hash[:opts]}, #{ext_hash[:params]}"
			      @stack.insert_before 0,  ext_hash[:ext], ext_hash[:opts], ext_hash[:params]
			    end
			    if klass_context_key == "query" then
			      #NOTE CQRS Query
			      
			      #TODO Should automatically insert {:cqrs => cqrs_query} into the opts. 
			      #TODO That way DSFs don't need to worry about specifiyin cqrs but only about using the query keyword when requiring a query
			      $log.debug "klass_construct_key #{klass_construct_key} | klass_construct_value #{klass_construct_value}"
			      #NOTE add store middleware for query
			      @stack.insert_before 0, Mushin::Store, {}, {}
			      stack_data = @stack.call
			      store(data_key: klass_construct_key.to_sym, data_value: stack_data)
			    else
			      #NOTE CQRS Command 
			      @stack.call
			    end
			  end
			end
		      end
		      instance_eval &context_block
		      klass_context_set[klass_context_key].each do |klass_construct_hash|
			klass_construct_hash.keys.each do |method_key| 
			  instance_eval("undef :#{method_key}")
			end
			$log.debug "construct_key #{klass_context_key} is undef-ed"
		      end
		    end
		  end
		end
		(!domain_block.nil?) ? (instance_eval &domain_block;) : (fail "a domain_block is required";)
	      end
	    end
	  end 
	  (!construct_block.nil?) ? (instance_eval &construct_block; @context_hash[@context_keyword] << @construct_hash; undef :use;) : (fail "construct_block please";)
	end 
	#TODO maybe i can define @@dsl_tree as an instance attribute and use it normally from inside the :initialize method of the object
	(!context_block.nil?) ? (instance_eval &context_block; @@dsl_tree << @context_hash; undef :construct;) : (fail "context_block please";)
      end 
    end
  end
end
