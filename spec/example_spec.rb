require 'instantiator'
require 'ostruct'

describe Instantiator  do
  context 'with a simple client' do
    before do
      @client = Class.new do
        extend Instantiator
        instance(:object) {rand}
      end
    end
    
    subject {@client.new}
    
    it 'it instantiates object once' do
      subject.object.should be == subject.object
    end
  end

  context 'with two clients for the same service' do
    before do
      @client = Class.new do
        extend Instantiator
        instance(:service) {rand}
        instance(:client1) {[service]}
        instance(:client2) {[service]}
      end
    end
    
    subject {@client.new}
    
    it 'it instantiates service once' do
      subject.client1[0].should be == subject.client1[0]
    end
  end

  context 'when there is a circular dependency' do
    before do
      @client = Class.new do
        extend Instantiator
        instance(:valueA) {OpenStruct.new(:b => valueB)}
        instance(:valueB) {OpenStruct.new(:a => valueA)}
      end
    end
    
    subject {@client.new}
    
    it 'the first object has a normal reference to the second' do
      subject.valueA.b.should == subject.valueB
    end
    
    it 'the second object has a lazyProxy to the first' do
      subject.valueA
      subject.valueB.a.should_not == subject.valueA
    end
  end

  context 'where there is an externa' do
    before do
      @client = Class.new do
        extend Instantiator
        
        external_instance(:thing)
      end
    end

    subject {@client.new}

    context 'and it is not defined' do
      it 'thing is nil' do
        subject.thing.should be_nil
      end
    end

    context 'and it is defined' do
      before do
        subject.thing = 2
      end
      it 'thing is as assigned' do
        subject.thing.should be == 2
      end
    end
  end

  context 'an external from one class can be set in another' do
    before do
      @source = Class.new do
        extend Instantiator

        external_instance :value
        instance(:list) {[value]}
      end

      @client = Class.new do
        extend Instantiator
        def initialize(source)
          source.value = my_value
          @source = source
        end

        instance(:my_value) {4}
        instance(:wrapper) {{:data => @source.list}}
      end
    end
    subject {@client.new(@source.new)}
    it 'links things together' do
      subject.wrapper.should be == {:data => [4]}
    end

  end
end


