module SimplesIdeias
  module Layout
    def self.included(base)
      # extending actioncontroller
      base.send :include, InstanceMethods
      base.send :extend, ClassMethods
      
      # setting attribute
      base.write_inheritable_attribute  :has_layout_options, []
      base.class_inheritable_reader     :has_layout_options
      
      # define plugin before_filter
      base.before_filter :choose_layout
    end
    
    module ClassMethods
      # has_layout 'site', :only => %w(faq feedback)
      # has_layout 'admin', :except => %w(index)
      # has_layout 'admin', :if => proc{ admin_page? }
      # has_layout 'site', :unless => :some_instance_method
      def has_layout(layout_name, options=nil)
        has_layout_options << [layout_name, options]
      end
    end
    
    module InstanceMethods
      private
        def choose_layout
          # set class attribute as local
          has_layout_options = self.class.has_layout_options
          
          return if has_layout_options.empty?
          
          has_layout_options.each do |config|
            layout_name = nil
            name, options = config
            
            # just process options if is not nil;
            # maybe somebody used has_layout method instead of
            # layout
            unless options.nil?
              # process :except and :only options
              if actions = options[:only]
                compares_to = true
              elsif actions = options[:except]
                compares_to = false
              end
              
              if actions
                valid_action = [actions].flatten.compact.map(&:to_s).include?(self.action_name) == compares_to
              else
                valid_action = true
              end
            
              # process :if and :unless options
              if callback = options[:if]
                compares_to = true
              elsif callback = options[:unless]
                compares_to = false
              end
              
              if callback
                valid_condition = has_layout_execute_callback(callback) == compares_to
              else
                valid_condition = true
              end
              
              if valid_action && valid_condition
                layout_name = name
              else
                next
              end
            end
            
            self.class.layout(layout_name) if layout_name
          
            # if options hasn't been set, continue to the
            # next rule
            break if layout_name && !options.nil?
          end
        end
        
        def has_layout_execute_callback(callback)
          if callback.respond_to?(:call)
            callback.call(self)
          else
            send(callback)
          end
        end
    end
  end
end