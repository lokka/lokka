# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "Snippet" do
  after { Snippet.destroy }

  context 'with id 1' do
    subject { Factory(:snippet, :id => 1) }
    its(:edit_link) { should eq('/admin/snippets/1/edit') }
  end
end
