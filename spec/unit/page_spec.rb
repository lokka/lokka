require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  describe '.first' do
    it { lambda { Page.first }.should_not raise_error }
  end
end
