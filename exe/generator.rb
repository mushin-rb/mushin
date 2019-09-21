require 'thor'
require 'thor/group'

module Mushin 
  class Generator < Thor::Group
    include Thor::Actions

    no_commands do 
      def check homepage
	if homepage.nil? then 
	  raise "homepage can't be empty"
	else
	  if homepage.include? "http://" then
	    return homepage
	  elsif homepage.include? "https://" then
	    return homepage
	  else
	    return "http://" + homepage
	  end
	end
      end
    end

    desc 'Generate Ext'
    def generate_ext name: , summary: "", description: "", homepage: "", license: ""
      if summary.nil?  then summary = "a mushin generated framework" end
      if description.nil? then description = "a mushin generated framework" end
      if homepage.nil? then homepage = "http://mushin-rb.github.io/" end
      if license.nil? then license = "MIT" end

      homepage = check(homepage)
     
      #TODO added this to make sense of what is an ext and what is a dsf!!
      name = "mushin_ext_" + name
      
      system("bundle gem #{name}")

      file =  "#{name.to_s}/lib/#{name}.rb"
      @require_gem = <<-FOO
      require 'mushin'
      require_relative '#{name}/version'
      FOO
      gsub_file file, /^.*\b(version)\b.*$/ do |match|
	match = @require_gem
      end

      @content = <<-FOO
      class Ext 
	using Mushin::Ext 

	def initialize app=nil, opts={}, params={}
	  @app 		= app
	  @opts 	= opts
	  @params 	= params 
	end

	def check_params *keys
	  return (keys.all? {|key| (@params.key?(key) && !@params[key].nil?)})
	end

	def call env 
	  env ||= Hash.new 

	  case @opts[:cqrs]
	  when :cqrs_query 
	    #inbound code
	    @app.call(env)
	    #outbound code
	  when :cqrs_command
	    #inbound code
	    @app.call(env)
	    #outbound code
	  else
	    raise "#{name} requires you to specify if your cqrs call is command or query? example: opts[:cqrs_query] = true"
	  end

	end
      end
      FOO

=begin
# generate an additional spec folder and delete the test folder
 add to automatic mushin minitest::spec generated code
before do 
 @env = {}
end
  it "ext" do
    #NOTE must specifiy the opts_query true or false while testing the extensions, but if the extenstion is called via a DSF, DSF automatically carry it out
    opts        = {:cqrs => :cqrs_command}
    params      = {:username => @secrets["github"]["login"], :password => @secrets["github"]["password"]}
    @ext        = Github::Ext.new(Proc.new {}, opts, params)

    @env[:repo_local_path].must_be_nil
    @ext.call(@env)
    @env[:repo_local_path].must_equal "somthing"
  end
=end

      gsub_file file, '# Your code goes here...' do |match|
	match = @content
      end

      @gemspec = <<-FOO

spec.add_dependency 'mushin'
end
      FOO
      puts "adding `mushin` gem as a dependency"
      gemspec_file =  "#{name.to_s}/#{name.to_s}.gemspec"
      gsub_file gemspec_file, /\s(\w+)\Z/ do |match|
	match = @gemspec 
      end

      #puts "amending gemspec with gem name #{"mushin_ext_" + name.downcase}" 
      #gsub_file gemspec_file, /"#{name}"/ do |match|
      #	match = "'#{"mushin_ext_" + name.downcase}'"
      #end

      puts "amending gemspec with gem summary" 
      gsub_file gemspec_file, /%q{TODO: Write a short summary, because Rubygems requires one.}/  do |match|
	match = "%q{#{summary}}" 
      end

      puts "amending gemspec with description" 
      gsub_file gemspec_file, /%q{TODO: Write a longer description or delete this line.}/ do |match|
	match = "%q{#{description}}" 
      end

      puts "amending gemspec with homepage" 
      gsub_file gemspec_file, /"TODO: Put your gem's website or public repo URL here."/ do |match|
	match = "'#{homepage}'"
      end

      puts "amending gemspec with license" 
      gsub_file gemspec_file, /"MIT"/ do |match|
	match = "'#{license}'"
      end

      #NOTE renaming lib/name.rb file to be able to require the gem with the same name 
      #puts "renaming lib/#{name}.rb to lib/mushin_ext_#{name.downcase}.rb " 
      #system("mv ./#{name}/lib/#{name}.rb ./#{name}/lib/mushin_ext_#{name.downcase}.rb")

      readme_file =  "#{name.to_s}/README.md"
      gsub_file readme_file, /#{name}/ do |match|
	match = "#{"mushin_ext_" + name.downcase}"
      end
    end


    desc 'Generate DSF'
    def generate_dsf name: , summary: "", description: "", homepage: "", license: ""

      if summary.nil?  then summary = "a mushin generated framework" end
      if description.nil? then description = "a mushin generated framework" end
      if homepage.nil? then homepage = "http://mushin-rb.github.io/" end
      if license.nil? then license = "MIT" end

      homepage = check(homepage)
      name = "mushin_dsf_" + name
      system("bundle gem #{name}")


      file =  "#{name.to_s}/lib/#{name.gsub("-", "/")}.rb"

      @require_gem = <<-FOO
require 'mushin'
require_relative '#{name}/version'
      FOO
      puts "requiring `mushin`"
      gsub_file file, /^.*\b(version)\b.*$/ do |match|
	match = @require_gem
      end

      @snippet = <<-FOO
# Usage:
# #{name}::Domain.new do
# # use your #{name} DSL here 
# end
class Domain
# Define your #{name} DSL here
      using Mushin::Domain
      context :change_me do
	construct :change_me do
	  use ext: change_me, opts: {}, params: {}
	  #use ext: SSD::Ext                   , opts: {:path => :ssd_path, :cqrs => :cqrs_command}    , params: {:id => :ssd_id}
	end
      end
end
      FOO

      puts "adding a DSF code snippet"
      gsub_file file, '# Your code goes here...' do |match|
	match = @snippet
      end

      @gemspec = <<-FOO

spec.add_dependency 'mushin'
end
      FOO
      puts "adding `mushin` gem as a dependency"
      gemspec_file =  "#{name.to_s}/#{name.to_s}.gemspec"
      gsub_file gemspec_file, /\s(\w+)\Z/ do |match|
	match = @gemspec 
      end

      puts "amending gemspec with gem name #{"mushin_dsf_" + name.downcase}" 
      gsub_file gemspec_file, /"#{name}"/ do |match|
	match = "'#{"mushin_dsf_" + name.downcase}'"
      end


      puts "amending gemspec with summary" 
      gsub_file gemspec_file, /%q{TODO: Write a short summary, because Rubygems requires one.}/  do |match|
	match = "%q{#{summary}}" 
      end

      puts "amending gemspec with description" 
      gsub_file gemspec_file, /%q{TODO: Write a longer description or delete this line.}/ do |match|
	match = "%q{#{description}}" 
      end

      puts "amending gemspec with homepage" 
      gsub_file gemspec_file, /"TODO: Put your gem's website or public repo URL here."/ do |match|
	match = "'#{homepage}'"
      end

      puts "amending gemspec license" 
      gsub_file gemspec_file, /"MIT"/ do |match|
	match = "'#{license}'"
      end

      #puts "amending README.md" 
      #readme_file =  "#{name.to_s}/README.md"
      #gsub_file readme_file, /#{name}/ do |match|
      #	match = "#{"mushin_dsf_" + name.downcase}"
      #end

      #remove_file "./#{name}/lib/#{name}.rb"
      #create_file "./#{name}/lib/#{name}.rb"

      #NOTE renaming lib/name.rb file to be able to require the gem with the same name 
      #puts "renaming lib/#{name}.rb to lib/mushin_dsf_#{name.downcase}.rb " 
      #system("mv ./#{name}/lib/#{name}.rb ./#{name}/lib/mushin_dsf_#{name.downcase}.rb")

      #NOTE creates an empty /ext dir in the generated DSF for experimental extensions before extracting them into gems
      puts "creating an empty /ext dir for experimental extenstions"
      empty_directory "./#{name}/lib/#{name}/ext"
    end
  end
end
