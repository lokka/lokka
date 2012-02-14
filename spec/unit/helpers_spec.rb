require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Lokka::Helpers do
  context 'gravatar_image_url' do
    it 'should return image url' do
      gravatar_image_url('test@example.com').should eql('http://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0')
      gravatar_image_url().should eql('http://www.gravatar.com/avatar/00000000000000000000000000000000')
    end
  end
  context 'custom_permalink' do
    before do
      Option.permalink_enabled = true
      Option.permalink_format = "/%year%/%monthnum%/%day%/%slug%"
    end

    after do
      Option.permalink_enabled = false
    end

    it 'custom_permalink_parse split path valid and return Hash' do
      custom_permalink_parse('/2011/01/09/welcome').should ==
        {:year=>"2011", :monthnum=>"01", :day=>"09", :slug=>"welcome"}
    end
  end
end
