# =========================
# Prof. H's .irbrc file
# Last update: 2018-01-09
# =========================
# External gems required:
# -------------------------
# hirb

puts "loading..."

# Make gems available
require 'rubygems'

# include Date automatically as well as Time enhancements
require 'date'
require 'time'

# include my gem for doing Project Euler tasks and the like
# require 'boqwij'


# Create an alias for a quick exit
alias q exit


ANSI = {}
ANSI[:RESET]     = "\e[0m"
ANSI[:BOLD]      = "\e[1m"
ANSI[:UNDERLINE] = "\e[4m"
ANSI[:LGRAY]     = "\e[0;37m"
ANSI[:GRAY]      = "\e[0;90m"
ANSI[:RED]       = "\e[31m"
ANSI[:GREEN]     = "\e[32m"
ANSI[:YELLOW]    = "\e[33m"
ANSI[:BLUE]      = "\e[34m"
ANSI[:MAGENTA]   = "\e[35m"
ANSI[:CYAN]      = "\e[36m"
ANSI[:WHITE]     = "\e[37m"

# Build a simple colorful IRB prompt
IRB.conf[:PROMPT][:SIMPLE_COLOR] = {
  :PROMPT_I => "#{ANSI[:BLUE]}>>#{ANSI[:RESET]} ",
  :PROMPT_N => "#{ANSI[:BLUE]}>>#{ANSI[:RESET]} ",
  :PROMPT_C => "#{ANSI[:RED]}?>#{ANSI[:RESET]} ",
  :PROMPT_S => "#{ANSI[:YELLOW]}?>#{ANSI[:RESET]} ",
  :RETURN   => "#{ANSI[:GREEN]}=>#{ANSI[:RESET]} %s\n",
  :AUTO_INDENT => true }

# Load the readline module.
IRB.conf[:USE_READLINE] = true
 
# Replace the irb(main):001:0 with a simple >>
IRB.conf[:PROMPT_MODE]  = :SIMPLE
 
# Tab completion
require 'irb/completion'
 
# Automatic indentation
IRB.conf[:AUTO_INDENT]=true
 
# Save History between irb sessions
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# Loading extensions of the console. This is wrapped
# because some might not be included in your Gemfile
# and errors will be raised.
def extend_console(name, care = true, required = true)
  if care
    require name if required
    yield if block_given?
    $console_extensions << "#{ANSI[:GREEN]}#{name}#{ANSI[:RESET]}"
  else
    $console_extensions << "#{ANSI[:GRAY]}#{name}#{ANSI[:RESET]}"
  end
rescue LoadError
  $console_extensions << "#{ANSI[:RED]}#{name}#{ANSI[:RESET]}"
end
$console_extensions = [] 



# Hirb is a mini view framework for console applications, designed 
# to make formatting of ActiveRecord objects easier on the eyes
# http://tagaholic.me/2009/03/13/hirb-irb-on-the-good-stuff.html
extend_console 'hirb' do
  Hirb.enable
  extend Hirb::Console
end



# # Trick I like from Thoughtbot's Dan Croak to show log info in console
# # http://robots.thoughtbot.com/post/159806033/irb-script-console-tips
# # Log to STDOUT if in Rails (useful for showing the SQL query run)
# if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
#  require 'logger'
#  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
# end

# The above trick doesn't work in Rails 3, but this does...
# ActiveRecord::Base.logger = Logger.new(STDOUT) if defined? Rails::Console 

# When you're using Rails 2 console, show queries in the console
extend_console 'rails2', (ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')), false do
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

# When you're using Rails 3 console, show queries in the console
extend_console 'rails3', defined?(ActiveSupport::Notifications), false do
  $odd_or_even_queries = false
  ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
    $odd_or_even_queries = !$odd_or_even_queries
    color = $odd_or_even_queries ? ANSI[:CYAN] : ANSI[:MAGENTA]
    event = ActiveSupport::Notifications::Event.new(*args)
    time  = "%.1fms" % event.duration
    name  = event.payload[:name]
    sql   = event.payload[:sql].gsub("\n", " ").squeeze(" ")
    puts "  #{ANSI[:UNDERLINE]}#{color}#{name} (#{time})#{ANSI[:RESET]}  #{sql}"
  end
end

# Simple methods in Rails console to get names of tables, columns(given a table), and models
def tables
  ActiveRecord::Base.connection.tables.sort!
end

def columns(table)
  ActiveRecord::Base.connection.columns(table).map(&:name).sort!
end

def models
  tables.select{|t| t != "schema_migrations"}.map{|t| t.underscore.singularize.camelize.to_sym}
end