# Credits to https://gist.github.com/ab for source: https://gist.github.com/ab/3161648 

# Colorizes the output of the standard library logger, depending on the logger level:
# To adjust the colors, look at Logger::Colors::SCHEMA and Logger::Colors::constants

require 'logger' 
require 'date'

module Mushin
  class Logger < Logger
    # Colorizes the output of the standard library logger, depending on the logger level:
    # To adjust the colors, look at Logger::Colors::SCHEMA and Logger::Colors::constants
    #
    # LEVELS
    #========
    # UNKNOWN: 	An unknown message that should always be logged.
    # FATAL: 	An unhandleable error that results in a program crash.
    # ERROR: 	A handleable error condition.
    # WARN: 	A warning.
    # INFO: 	Generic (useful) information about system operation.
    # DEBUG: 	Low-level information for developers.
    #class Logger < Logger
    module Colors
      NOTHING      = '0;0'
      BLACK        = '0;30'
      RED          = '0;31'
      GREEN        = '0;32'
      BROWN        = '0;33'
      BLUE         = '0;34'
      PURPLE       = '0;35'
      CYAN         = '0;36'
      LIGHT_GRAY   = '0;37'
      DARK_GRAY    = '1;30'
      LIGHT_RED    = '1;31'
      LIGHT_GREEN  = '1;32'
      YELLOW       = '1;33'
      LIGHT_BLUE   = '1;34'
      LIGHT_PURPLE = '1;35'
      LIGHT_CYAN   = '1;36'
      WHITE        = '1;37'

      SCHEMA = {
	STDOUT => %w[nothing green brown red purple cyan],
	#STDERR => %w[nothing green yellow light_red light_purple light_cyan],
	STDERR => %w[dark_gray nothing yellow light_red light_purple light_cyan],
      }
    end

    alias format_message_colorless format_message

    def format_message(level, *args)
      if self.class::Colors::SCHEMA[@logdev.dev] && @logdev.dev.tty?
	begin
	  index = self.class.const_get(level.sub('ANY','UNKNOWN'))
	  color_name = self.class::Colors::SCHEMA[@logdev.dev][index]
	  color = self.class::Colors.const_get(color_name.to_s.upcase)
	rescue NameError
	  color = '0;0'
	end
	"\e[#{color}m#{format_message_colorless(level, *args)}\e[0;0m"
      else
	format_message_colorless(level, *args)
      end
    end

    def rainbow(*args)
      SEV_LABEL.each_with_index do |level, i|
	add(i, *args)
      end
    end
  end



  def self.logger(shift_age: 'daily',
		  datetime_format: '%Y-%m-%d %H:%M:%S',
		  log_dir: 'log'
		 )
    #Dir.mkdir(log_dir) unless File.exists?(log_dir)
    #logger_file = "#{log_dir}/#{DateTime.now.strftime('%m_%d_%Y')}.log"
    #file = File.open(logger_file, File::APPEND | File::WRONLY | File::CREAT)
    #file.sync = true
    #file = File.open(logger_file, File::WRONLY | File::APPEND) 
    #@log = Mushin::Logger.new("| tee " + file.path, shift_age)
    @log = Mushin::Logger.new(STDOUT)
    @log.datetime_format = datetime_format
    #@log.progname = 'eventstream'
    #@log.format_message 'DEBUG', 

    @log.info "Mushin Log Levels: DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN" 
    return @log
  end

end
=begin
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
=end
