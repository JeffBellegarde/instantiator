require 'instantiator'

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

  context 'when two wirings have the sane name' do
    before do
      class Client1
        extend Instantiator
        instance(:value) {1}
      end

      class Client2
        extend Instantiator
        instance(:value) {2}
      end
    end
    
    subject {[Client1.new, Client2.new]}
    
    it 'they are independent' do
      [subject[0].value, subject[1].value].should == [1, 2]
    end
  end
end


