require 'middleware'

require_relative "mushin/version"
require_relative "mushin/logger"
require_relative "mushin/stack"
require_relative "mushin/ext"
require_relative "mushin/test_helper"
require_relative "mushin/store"
require_relative "mushin/domain"

#NOTE maybe later
#require_relative "mushin/es/event"
#require_relative "mushin/es/event_stream"
#require_relative "mushin/domain"
#require_relative "mushin/generator"
#require_relative "mushin/bot"

module Mushin
  $log = Mushin.logger #Logger.new(STDOUT)

  # Set logging level to info 
  $log.level = Logger::INFO
end
