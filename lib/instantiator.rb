require "instantiator/version"

module Instantiator
  @@instances = {}
  def instance(name, &block)
    self.send(:define_method, name) do
      @@instances[name] ||= begin
                              self.instance_eval(&block)
                            end
    end
  end

end
