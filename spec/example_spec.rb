require 'instantiator'

describe Instantiator  do
  context 'with a simple client' do
    before do
      class Client
        extend Instantiator
        instance(:object) {rand}
      end
    end
    
    subject {Client.new}
    
    it 'it instantiates object once' do
      subject.object.should be == subject.object
    end
  end
  context 'with two clients for the same service' do
    before do
      class Client
        extend Instantiator
        instance(:service) {rand}
        instance(:client1) {[service]}
        instance(:client2) {[service]}
      end
    end
    
    subject {Client.new}
    
    it 'it instantiates service once' do
      subject.client1[0].should be == subject.client1[0]
    end
  end
end


