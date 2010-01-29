# Load application RSpec helper
begin
  require File.dirname(__FILE__) + "/../../../../spec/spec_helper"
rescue LoadError
  puts "Your application hasn't been bootstraped with RSpec.\nI'll do it on my own!\n\n"
  system "cd '#{File.dirname(__FILE__) + "/../../../../"}' && script/generate rspec"
  puts "\n\nRun `rake spec` again."
  exit
end

# Establish connection with in memory SQLite 3 database
ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"

# Load controllers
require File.dirname(__FILE__) + "/resources/controllers"

# Set views directory
ApplicationController.prepend_view_path File.dirname(__FILE__) + "/resources/views"

# Load custom matchers
require "has_layout/spec/matchers"

# Create an alias for lambda
alias :doing :lambda
