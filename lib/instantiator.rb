require "instantiator/version"

module Instantiator

  def instance(name, &block)
    self.send(:define_method, name) do
      self.instance_variable_set(:@instances, {}) unless self.instance_variable_defined? :@instances
      self.instance_variable_get(:@instances)[name] ||= self.instance_eval(&block)
    end
  end
end
