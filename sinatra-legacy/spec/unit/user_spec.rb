# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  subject { user }

  shared_examples 'user with validation' do
    it 'saves successfully' do
      subject.save.should be_true
    end

    context 'with blank name' do
      before { user.name = '' }

      it 'fails to save' do
        subject.save.should_not be_true
      end
    end

    context 'with blank email' do
      before { user.email = '' }

      it 'fails to save' do
        subject.save.should_not be_true
      end
    end

    context 'with trailing whitespaces' do
      before do
        user.name = ' Johnny Depp '
      end

      it 'trims whitespace after save' do
        subject.save
        subject.name.should eq 'Johnny Depp'
      end
    end
  end

  describe '#save' do
    let(:user) do
      User.new(name: 'Johnny',
               email: 'johnny@example.com',
               password: 'password',
               password_confirmation: 'password')
    end
    it_behaves_like 'user with validation'
  end

  describe '#update' do
    let!(:user) { create :user, name: 'Johnny' }

    it_behaves_like 'user with validation'
  end
end

describe GuestUser do
  it { should_not be_admin }
  its(:permission_level) { should eq 0 }
end
