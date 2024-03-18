# frozen_string_literal: true

require 'rspec'
require_relative '../lib/user'

RSpec.describe User do
  let(:valid_params) do
    { 'id' => 1, 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com', 'company_id' => 1,
      'email_status' => true, 'active_status' => true, 'tokens' => 100 }
  end

  describe '#initialize' do
    context 'with valid parameters' do
      it 'creates a new user instance' do
        expect { User.new(valid_params) }.not_to raise_error
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        { 'id' => 1, 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com', 'company_id' => 1,
          'email_status' => true, 'active_status' => true, 'tokens' => 100 }
      end
      it 'raises an error for missing id' do
        params['id'] = nil
        expect { User.new(params) }.to raise_error(ArgumentError, "Id can't be nil")
      end
      it 'raises an error for malformed email' do
        params['email'] = 'invalid_email'
        expect { User.new(params) }.to raise_error(ArgumentError, 'Malformed email')
      end
    end
  end

  describe '#to_s' do
    let(:user) { User.new(valid_params) }

    it 'returns string representation of the user' do
      expect(user.to_s).to eq("Doe, John, john@example.com\n")
    end
  end

  describe '#add_token' do
    let(:user) { User.new(valid_params) }

    it 'adds tokens to the user' do
      expect { user.add_token(50) }.to change { user.tokens }.by(50)
    end

    it 'returns information about token balances' do
      expect(user.add_token(50)).to eq("Previous Token Balance, 100\n      New Token Balance 150\n")
    end
  end
end
