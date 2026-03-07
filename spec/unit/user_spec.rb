# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  subject { user }

  shared_examples 'user with validation' do
    it 'saves successfully' do
      expect(subject.save).to be_truthy
    end

    context 'with blank name' do
      before { user.name = '' }

      it 'fails to save' do
        expect(subject.save).to be_falsey
      end
    end

    context 'with blank email' do
      before { user.email = '' }

      it 'fails to save' do
        expect(subject.save).to be_falsey
      end
    end

    context 'with trailing whitespaces' do
      before do
        user.name = ' Johnny Depp '
      end

      it 'trims whitespace after save' do
        subject.save
        expect(subject.name).to eq 'Johnny Depp'
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
  subject { GuestUser.new }
  it { expect(subject).not_to be_admin }
  it { expect(subject.permission_level).to eq 0 }
end
