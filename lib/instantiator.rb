require "instantiator/version"

module Instantiator
  @@instances = {}
  def instance(name, &block)
    self.send(:define_method,name) do
      @@instances[name] ||= yield
    end
  end

end
