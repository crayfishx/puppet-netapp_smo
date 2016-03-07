require 'spec_helper'
describe 'smo' do

  context 'with defaults for all parameters' do
    it { should contain_class('smo') }
  end
end
