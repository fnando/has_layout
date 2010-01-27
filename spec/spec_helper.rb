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

Spec::Matchers.define :render_layout do |expected_layout|
  expected_layout = "layouts/#{expected_layout}"
  normalize_layout_name = proc {|n| n.gsub(/^layouts\//, "") }

  match do |response|
    response.layout == expected_layout
  end

  failure_message_for_should  do |response|
    "expected #{normalize_layout_name.call(expected_layout).inspect} layout to be rendered but was #{normalize_layout_name.call(response.layout).inspect}"
  end

  failure_message_for_should_not  do |response|
    "expected #{normalize_layout_name.call(expected_layout).inspect} layout not to be rendered"
  end
end

# Create an alias for lambda
alias :doing :lambda
