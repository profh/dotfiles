# =========================
# Prof. H's .irbrc file
# Last update: 2009-11-23
# =========================
# External gems required:
# -------------------------
# chronic 
# what_methods 
# map_by_method
# wirble
# hirb


# Make basic gems available
begin
  # Have to start with rubygems
  require 'rubygems'
 
  # include Pretty Print method
  require 'pp'

  # include Date automatically as well as Time enhancements
  require 'date'
  require 'time'
rescue LoadError => e
	warn "Couldn't load basic gems: #{e}"
end

# Have to have the Chronic gem (n'est-ce pas, Brad?)
begin
  require 'chronic'
rescue LoadError => e
	warn "Couldn't load Chronic: #{e}"
end

# Create an alias for a quick exit
alias q exit
  
# Dr Nic's gem to find what methods yield the desired result
# http://drnicwilliams.com/2006/10/12/my-irbrc-for-consoleirb/
begin
  require 'what_methods'
rescue LoadError => e
	warn "Couldn't load what_methods: #{e}"
end

# Add in Dr. Nic's map_by_method while we're at it
# http://drnicutilities.rubyforge.org/map_by_method/
begin
  require 'map_by_method'
rescue LoadError => e
  warn "Couldn't load map_by_method: #{e}"
end 

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
 
# Wirble is a set of enhancements for irb
# http://pablotron.org/software/wirble/README
# Implies require 'pp', 'irb/completion', and 'rubygems'
begin
  require 'wirble'
  Wirble.init
 
  # Enable colored output (off by default)
  # Look at the readme file if you want to edit the colors
  Wirble.colorize
rescue LoadError => e
  warn "Couldn't load Wirble: #{e}"
end

# Hirb is a mini view framework for console applications, designed 
# to make formatting of ActiveRecord objects easier on the eyes
# http://tagaholic.me/2009/03/13/hirb-irb-on-the-good-stuff.html
begin
	require 'hirb'
  Hirb::View.enable
rescue LoadError => e
	warn "Couldn't load Hirb: #{e}"
end



# Trick I like from Thoughtbot's Dan Croak to show log info in console
# http://robots.thoughtbot.com/post/159806033/irb-script-console-tips
# Log to STDOUT if in Rails (useful for showing the SQL query run)
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
 require 'logger'
 RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end


# This last one is really optional and I don't really use it but 
# it could be valuable for students so I'm including it here ...
# Code from sebastian delmont (mod by nikosd) to add a .pm method to
# an object and allow you to print out the methods list from irb
# http://snippets.dzone.com/posts/show/2916
class Object
  ANSI_BOLD       = "\033[1m"
  ANSI_RESET      = "\033[0m"
  ANSI_LGRAY    = "\033[0;37m"
  ANSI_GRAY     = "\033[1;30m"

  # Print object's methods
  def pm(*options)
    methods = self.methods
    methods -= Object.methods unless options.include? :more
    filter = options.select {|opt| opt.kind_of? Regexp}.first
    methods = methods.select {|name| name =~ filter} if filter

    data = methods.sort.collect do |name|
      method = self.method(name)
      if method.arity == 0
        args = "()"
      elsif method.arity > 0
        n = method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")})"
      elsif method.arity < 0
        n = -method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")}, ...)"
      end
      klass = $1 if method.inspect =~ /Method: (.*?)#/
      [name, args, klass]
    end
    max_name = data.collect {|item| item[0].size}.max
    max_args = data.collect {|item| item[1].size}.max
    data.each do |item| 
      print " #{ANSI_BOLD}#{item[0].rjust(max_name)}#{ANSI_RESET}"
      print "#{ANSI_GRAY}#{item[1].ljust(max_args)}#{ANSI_RESET}"
      print "   #{ANSI_LGRAY}#{item[2]}#{ANSI_RESET}\n"
    end
    data.size
  end
end
