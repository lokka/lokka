require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
      @user.email.should eq('johnny@example.com')
    end
    it "should not be able to register a user when name is blank" do
      @user.name = ''
      @user.save.should_not be_true
    end
    it "should not be able to register a user when email is blank" do
      @user.email = ''
      @user.save.should_not be_true
    end

    describe 'strip spaces' do
      it "should strip anteroposterior spaces" do
        @user.name = ' Johnny '
        @user.save.should be_true
        @user.name.should eq('Johnny')
      end
      it "should not strip middle spaces" do
        @user.name = ' Johnny Depp '
        @user.save.should be_true
        @user.name.should eq('Johnny Depp')
      end
    end
  end

  context "update" do
    before { @user = Factory(:user, :name => 'Johnny') }
    it "should be updated" do
      @user.name = 'Jack'
      @user.save.should be_true
      @user.name.should eq('Jack')
    end
    it "should not be updated when name is blank" do
      @user.name = ''
      @user.save.should_not be_true
    end
    it "should not be updated when email is blank" do
      @user.email = ''
      @user.save.should_not be_true
    end

    describe 'strip spaces' do
      it "should strip anteroposterior spaces" do
        @user.name = ' Jack '
        @user.save.should be_true
        @user.name.should eq('Jack')
      end
      it "should not strip middle spaces" do
        @user.name = ' Jack Sparrow '
        @user.save.should be_true
        @user.name.should eq('Jack Sparrow')
      end
    end
  end

  context "guest" do
    before { @guest =  GuestUser.new }
    it "not admin" do
      @guest.admin?.should be_false
    end
    it "permission leve 0" do
      @guest.permission_level.should eq(0)
    end
  end
end
