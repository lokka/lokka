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

    describe 'custom_permalink_fix' do
      it 'should return corrected URL by padding zero' do
        custom_permalink_fix('/2011/1/9/welcome').should == '/2011/01/09/welcome'
      end

      it 'should return nil for correct URL' do
        custom_permalink_fix('/2011/01/09/welcome').should be_nil
      end

      it 'should return nil when any error is raised' do
        Option.permalink_format = "/%year" # wrong format to raise error
        custom_permalink_fix('/2011').should be_nil
      end
    end

    describe 'custom_permalink_entry' do
      it 'should parse date condition' do
        Entry.should_receive(:first).with(:slug => 'slug',
                                     :created_at.gte => Time.local(2011, 1, 9),
                                     :created_at.lt => Time.local(2011, 1, 9, 23, 59, 59))
        custom_permalink_entry('/2011/01/09/slug')
      end

      it 'should return nil when any error is raised' do
        custom_permalink_entry('/no/such/path').should be_nil
      end
    end
  end
end
