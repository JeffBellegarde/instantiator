require "instantiator/version"

module Instantiator

  def instance(name, &block)
    define_method name do
      attribute_name = "@#{name}".to_sym
      if self.instance_variable_defined? attribute_name
        self.instance_variable_get attribute_name
      elsif
        self.instance_variable_set attribute_name, LazyProxy.new(&block)
        self.instance_variable_set attribute_name, self.instance_eval(&block)
      end
    end
  end

  def external_instance(name)
    attr_accessor name
  end

end
