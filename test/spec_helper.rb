ENV["RAILS_ENV"] = "test"

require File.expand_path("../../../../config/environment")
require "spec"
require "spec/rails"
require "ruby-debug"

class Object
  def self.unset_class(*args)
    class_eval do 
      args.each do |klass|
        eval(klass) rescue nil
        remove_const(klass) if const_defined?(klass)
      end
    end
  end
end

alias :doing :lambda