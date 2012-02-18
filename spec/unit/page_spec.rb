require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  describe '.first' do
    it { expect { Page.first }.not_to raise_error }
  end
end
