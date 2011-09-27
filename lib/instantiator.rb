require "instantiator/version"

module Instantiator

  def instance(name, &block)
    self.send(:define_method, name) do
      self.instance_variable_set(:@instances, {}) unless self.instance_variable_defined? :@instances
      self.instance_variable_set(:@partials, {}) unless self.instance_variable_defined? :@partials
      partials = self.instance_variable_get(:@partials)
      self.instance_variable_get(:@instances)[name] ||=
        begin
          if partials[name] 
            partials[name] 
          else
            partials[name] = LazyProxy.new(&block)
            instance = self.instance_eval(&block)
            partials[name] = nil
            instance
          end
        end
    end
  end


end
