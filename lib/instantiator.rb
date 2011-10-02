require "instantiator/version"

module Instantiator

  def instance(name, &block)
    define_method name do
      @instances ||= {}
      @instances[name] ||= 
        begin
          @instances[name] = LazyProxy.new(&block)
          self.instance_eval(&block)
        end
    end
  end

  def external_instance(name)
    define_method name do
      @instances ||= {}
      @instances[name]
    end
    define_method "#{name}=" do |value|
      @instances ||= {}
      @instances[name] = value
    end
  end

end
