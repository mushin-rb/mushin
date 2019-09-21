#TODO 
mushin itselef needs to be remade as a bundler generated gem to be able to run `bundle exec rake release` and similar, must use --exec too for adding mushin executables.

What is Mushin
===============
Mushin is a Domain-specific Framework Generator

What Mushin does?
=================
Mushin generates:
1) domain gems
2) domain extenstion gems

resource: bundle exec rake release
resource: bundle gem --help

How to use Mushin
=================
Directly via

Mushin::Stack.new do 
 use DomainSpecificExtA, opts, params
 use DomainSpecificExtB, opts, params
 use DomainSpecificExtC, opts, params
end

Indirectly via generating a domain-specific framework and using it instead to generate domain-specific Extentions.

Generate the framework via
```
mushin roll domainframeworkXYZ
```
then after installing the framework gem in your system, generate extentions via 
```
domainframeworkXYZ ext extentionXYZ
```
```ruby
DomainframeworkXYZ::Stack.new do 
 use extentionXYZ1, opts, params
 use extentionXYZ2, opts, params
 use extentionXYZ3, opts, params
end
```

Domain-specfic Extentions duck types to the following interface:
```ruby
class ExtensionXYZ 
 def initialize(app); end
 def call(env); end
end
```

######################################################################
Mushin Books uses declarative DSL for describing what an expert want to do.
https://www.netguru.co/blog/imperative-vs-declarative


Mushin previously had crazy bugs as due to mutable objects, this is tend to be 
avoided in the current implementation.

=== What is Mushin?
Mushin is a specification interface between your ruby application and domain-specific frameworks.
It provides generation capabilities to kick start developing your own domain-specific framework based on the interface, thats the Mushin way.
Following the Mushin way, new developers can easily start using your new domain-specific framework in their applications. as they expect it to behave similarlar to other mushin-based frameworks.

Mushin is a spec describing how an application should implement a domian-specifc rules and actions, similar in the sense that rack is a spec describing how webservers and webframeworks should implement a webrequest and webresponse, following this anology a webrequest the equvilant to a mushin rule, and a webresponse the equivlant of mushin response. and mushin rules engine is similar to rails routecontroller, except that mushin rules engine may activate a number of actions for each rule invoked. 

=== Mushin Goal
Mushin goal is to be in service for preventing every ruby application from complecting different domain knolwedge, in the sense that via following the mushin way, each domain knoweldge is mature in isolation with its own middlewares, in the realm of its own domain-specific framework.

=== What Mushin do?
Mushin do to a ruby application and domain-specific frameworks, what rack does to webservers and webframeworks. Except that rack doesn't offer code generation capabilities for webframework developers. Note: in a general sense a webframework is a domains-specific framework for the 'web' domain, see TheMetal project for the future of rack and how the ruby community been trying to further enahnce rack.

=== Mushin TDD

=== Writing Mushin Middleware
It is a good practice to isolate the middleware from the logic, in the sense that that the logic code inside the call method of your middleware should only be concrned with descion flow and passing variables to your logic methods that typically will reside on its own classes.

===== Example writing a Redis DataStore Middleware
- first we start by writing the specs for our middleware which is typical and can be gernated in the future via mushin
mushin_middleware_spec.rb
- then we move own to write the actual middleware
##### this is a mushin middlware
class redis
	def app(env)
	end
	def call(env)
		# here add your if, case statmetents
  	end
end
- then we write the spec for our logic class that contain the methods for our logic

- and finally we write the actually logic class that make the spec pass
#####  this is a logic file for the middleware of mushin
class RedisDS
#####  here each function is used and tested in as a spec in isolation
end

=== Mushin testing

##### TODO Mushin::MockRequest, similar to rack's stack let(:request) { Rack::MockRequest.new(stack) }


=== Mushin Generation capabilities
each new version of mushin contains a blue print of the domain-speicifc framework, it copies those files into a destenation directory and then uses grep to replace various code snippet 


=== Virtual Currency Domain Framework, that includes middlewares for different client apis and gems to work with virtualcurrencies
