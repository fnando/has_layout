module SimplesIdeias
  module Layout
    module ClassMethods
      def has_layout(name, options = nil)
        self.has_layout_options << [name, options]
      end
    end

    module InstanceMethods
      private
        def choose_layout
          layout_name = nil

          self.class.has_layout_options.each do |layout_name, options|
            # The layout has been set without any conditions
            # so we can skip the layout lookup
            break unless options

            # Set :only and :except options
            if options[:only]
              compares_to = true
              actions = options[:only]
            elsif options[:except]
              compares_to = false
              actions = options[:except]
            end

            # Process :only/:except condition
            if actions
              valid_action = [actions].flatten.compact.map(&:to_s).include?(self.action_name) == compares_to
            else
              valid_action = true
            end

            # Set :if and :unless options
            if callback = options[:if]
              compares_to = true
            elsif callback = options[:unless]
              compares_to = false
            end

            # Process :if/:unless condition
            if callback
              valid_condition = execute_layout_callback(callback) == compares_to
            else
              valid_condition = true
            end

            # This action is valid according to the conditions above,
            # so we can stop the layout lookup
            break if valid_action && valid_condition

            # Reset layout name
            layout_name = nil
          end

          # A layout name has been found, so we need to
          # set it on the controller
          self.class.layout layout_name
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