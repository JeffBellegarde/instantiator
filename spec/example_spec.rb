require 'instantiator'
require 'ostruct'

describe Instantiator  do
  context 'with a simple client' do
    before do
      class ClientSimple
        extend Instantiator
        instance(:object) {rand}
      end
    end
    
    subject {ClientSimple.new}
    
    it 'it instantiates object once' do
      subject.object.should be == subject.object
    end
  end

  context 'with two clients for the same service' do
    before do
      class ClientDouble
        extend Instantiator
        instance(:service) {rand}
        instance(:client1) {[service]}
        instance(:client2) {[service]}
      end
    end
    
    subject {ClientDouble.new}
    
    it 'it instantiates service once' do
      subject.client1[0].should be == subject.client1[0]
    end
  end

  context 'when there is a circular dependency' do
    before do
      class ClientLoop
        extend Instantiator
        instance(:valueA) {OpenStruct.new(:b => valueB)}
        instance(:valueB) {OpenStruct.new(:a => valueA)}
      end
    end
    
    subject {ClientLoop.new}
    
    it 'the first object has a normal reference to the second' do
      subject.valueA.b.should == subject.valueB
    end
    
    it 'the second object has a lazyProxy to the first' do
      subject.valueA
      subject.valueB.a.should_not == subject.valueA
    end
  end
end


