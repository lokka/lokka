require File.dirname(__FILE__) + '/spec_helper'

describe Lokka::Helpers do
  context 'gravatar_image_url' do
    it 'should return image url' do
      gravatar_image_url('test@example.com').should eql('http://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0')
      gravatar_image_url().should eql('http://www.gravatar.com/avatar/00000000000000000000000000000000')
    end
  end
end
