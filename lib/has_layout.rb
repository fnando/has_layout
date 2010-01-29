module SimplesIdeias
  module Layout
    def self.included(base)
      base.class_eval do
        extend SimplesIdeias::Layout::ClassMethods
        include SimplesIdeias::Layout::InstanceMethods

        cattr_accessor :layout_options
        layout :choose_layout
      end
    end

    module ClassMethods
      # Use +has_layout+ instead of the original +layout+ macro.
      # This one allows you to have multiple conditions on a single controller.
      #
      #   has_layout "website"
      #   has_layout "website", :only => "faq"
      #   has_layout "website", :only => %w(faq help)
      #   has_layout "website", :except => "index"
      #   has_layout "website", :except => %w(index edit)
      #   has_layout "website", :if => :public_page?
      #   has_layout "website", :if => proc { public_page? }
      #   has_layout "website", :unless => :private_page?
      #   has_layout "website", :unless => proc { private_page? }
      #
      # When providing a +proc+ the scope is the controller, so the above examples can be written as
      #
      #   class SampleController < ApplicationController
      #     private
      #       def private_page?
      #         true
      #       end
      #
      #       def public_page?
      #         false
      #       end
      #   end
      def has_layout(name, options = nil)
        self.layout_options ||= []
        self.layout_options << [name, options]
      end
    end

    module InstanceMethods
      private
        def choose_layout
          layout_name = nil
          rules = self.class.layout_options || []
require "ruby-debug"; debugger if $BREAKPOINT; true
          rules.each do |name, options|
            layout_name = name

            # There's no options, so we can use this
            # layout for every single action
            break unless options

            # Process conditions
            if options[:only]
              compares_to = true
              actions = options[:only]
            elsif options[:except]
              compares_to = false
              actions = options[:except]
            end

            if actions
              valid_action = [actions].flatten.compact.map(&:to_s).include?(self.action_name) == compares_to
            else
              valid_action = true
            end

            if callback = options[:if]
              compares_to = true
            elsif callback = options[:unless]
              compares_to = false
            end

            if callback
              valid_condition = execute_layout_callback(callback) == compares_to
            else
              valid_condition = true
            end

            # The current action is confirming to the conditions,
            # so we can use it
            break if valid_action && valid_condition

            # Damn... there's no rule for this action.
            # Skip to the next one!
            layout_name = nil
          end

          # There's a rule for this action, so
          # we can safely return it
          return layout_name if layout_name

          file_list = self.class.layout_list
          format = params[:format] || "html"
          controller_name = self.class.name.underscore.gsub(/_controller$/, "")

          # No layout file for XHR + HTML requests
          return false if format == "html" && request.xhr?

          # A file +#{controller}.#{format}.erb+
          file = file_list.find {|f| f =~ /\/layouts\/#{Regexp.escape(controller_name)}(.#{Regexp.escape(format)})?.erb/}
          return controller_name if file

          # A file +application.#{format}.erb+
          file = file_list.find {|f| f =~ /\/layouts\/application(.#{Regexp.escape(format)})?.erb/}
          return "application" if file

          # Render no layout
          nil
        end

        def execute_layout_callback(callback)
          if callback.respond_to?(:call)
            self.instance_eval(&callback)
          else
            send(callback)
          end
        end
    end
  end
end
