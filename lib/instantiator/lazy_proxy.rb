module Instantiator
  class LazyProxy
    def initialize(&block)
      @init_block = block
    end

    def method_missing(sym, *args, &block)
      real_object = @init_block.call()
      real_object.public_methods(false).each do |meth|
        (class << self; self; end).class_eval do
          define_method meth do |*args|
            real_object.send meth, *args
          end
        end
      end
      @init_block = nil
      real_object.send sym, *args, &block
    end
  end
end
