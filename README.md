# Mushin
mushin allows you to build your application ubiquies lagnague of the domain which is implmented as a declarative domain DSL.

In a mushin app there is two DSLs, domain developer DSL (provided via mushin) and app developer DSL(provided via the domain developer)

Context is a place to define a DSL
A Bounded Context can be considered as a miniature application, containing its own Domain,
own code and persistence mechanisms. Within a Bounded Context, there should be logical
consistency; each Bounded Context should be independent of any other Bounded Context.

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/mushin`. To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mushin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mushin

## Usage
```
mushin new domain
```
This command generates a new domain that consits of a context.rb and an empty directory of ext/

The context.rb requires mushin and require_relative everything in the ext directory. 
Its initialize &block acts as a simple dsl for all the methods it contains.

```
require 'mushin'
Dir['./ext/**/*.rb'].each{ |f| require_relative f }

class Context
 def initialize &block
  instance_eval &block
 end
end
```

```
mushin new ext
```
This command generates a new domain extension in the ext/ directory 

```
module Internal
end

class Main < Mushin::Ext # this raise an error if the inheriting class doens't have :initialize and :call                                                        
 include Internal

def initialize app=nil, opts={}, params={}
 @app      = app
 @opts     = opts
 @params   = params 
end

def call env 
#NOTE Utter Generated Code: used to provide you an env hash variable
env = Hash.new if env.nil? 

p "#{self} ------ Inbound maniuplation"
p env
p @params
env[:query] = @params[:query]
# Exception halt the middleware chain that backing out in a reverse order, works really well.
case
when env[:query].nil?, env[:query].empty?
#TODO https://www.sitepoint.com/ruby-error-handling-beyond-basics/
#TODO http://ieftimov.com/exception-handling-and-testing
#return raise EmptyQuery
p "empty is no good"
else 
env[:tpbbot] = search(env[:query])
end

@app.call(env)

p "#{self} ------ Outbound maniuplation"
p env

end

```
## Reading list
[domain-driven design servcies architecture](https://www.thoughtworks.com/insights/blog/domain-driven-design-services-architecture) .

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mushin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

