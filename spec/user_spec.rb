# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "User" do
  after { User.destroy }

  context "register" do
    before do
      @user = User.new(
        :name => 'Johnny',
        :email => 'johnny@example.com',
        :password => 'password',
        :password_confirmation => 'password'
      )
    end
    it "should be able to register a user" do
      @user.save.should be_true
      @user.name.should eq('Johnny')
    end
    it "should strip spaces" do
      @user.name = ' Johnny '
      @user.save.should be_true
      @user.name.should eq('Johnny')
    end
  end

  context "update" do
    before { Factory(:user, :name => 'Johnny') }
    it "should strip spaces" do
      user = User.first(:name => 'Johnny')
      user.name = ' Jack '
      user.save.should be_true
      user.name.should eq('Jack')
    end
  end
end
