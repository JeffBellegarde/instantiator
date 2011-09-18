require 'instantiator'

describe Instantiator  do
  context 'with a simple client' do
    class Client
      extend Instantiator
      instance(:object) {rand}
    end
    
    subject {Client.new}
    
    it 'it instantiates object once' do
      subject.object.should be == subject.object
    end
  end
  context 'with two clients for the same service' do
    class Client
      extend Instantiator
      instance(:service) {rand}
      instance(:client1) {[rand]}
      instance(:client2) {[rand]}
    end
    
    subject {Client.new}
    
    it 'it instantiates service once' do
      subject.client1[0].should be == subject.client1[0]
    end
  end
end


