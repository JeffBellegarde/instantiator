require 'instantiator/lazy_proxy'
require 'ostruct'

describe Instantiator::LazyProxy  do
  subject {Instantiator::LazyProxy.new {"b"}}
    
  it 'it copies methods form the source to proxy' do
    subject.size.should be == 1
  end

  it 'nonsense methods do not cause infinte loops' do
    expect {
      subject.foobar
    }.to raise_error(NoMethodError)
  end

end


