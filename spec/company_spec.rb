# frozen_string_literal: true

require 'rspec'
require_relative '../lib/company'
require_relative '../lib/user'

RSpec.describe Company do
  let(:valid_params) { { 'id' => 1, 'name' => 'Test Company', 'top_up' => 100, 'email_status' => true } }
  let(:invalid_params) { { 'id' => nil, 'name' => 'Test Company', 'top_up' => 1, 'email_status' => false } }

  describe '#initialize' do
    context 'with valid parameters' do
      it 'creates a new company instance' do
        expect { Company.new(valid_params) }.not_to raise_error
      end
    end

    context 'with invalid parameters' do
      it 'raises an error for missing id' do
        expect { Company.new(invalid_params) }.to raise_error(ArgumentError, "Id can't be blank")
      end
    end
  end

  describe '#add_user' do
    let(:company) { Company.new(valid_params) }
    let(:user) do
      User.new('id' => 1, 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com', 'company_id' => 1,
               'email_status' => true, 'active_status' => true, 'tokens' => 0)
    end

    it 'adds a user to the company' do
      expect { company.add_user(user) }.to change { company.users.length }.by(1)
    end
  end

  describe '#active_users' do
    let(:company) { Company.new(valid_params) }
    let(:user1) do
      User.new('id' => 1, 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com', 'company_id' => 1,
               'email_status' => true, 'active_status' => true, 'tokens' => 0)
    end
    let(:user2) do
      User.new('id' => 2, 'first_name' => 'Jane', 'last_name' => 'Smith', 'email' => 'jane@example.com', 'company_id' => 1,
               'email_status' => true, 'active_status' => false, 'tokens' => 0)
    end

    before do
      company.add_user(user1)
      company.add_user(user2)
    end

    it 'returns only active users' do
      expect(company.active_users).to contain_exactly(user1)
    end
  end

  describe '#users_to_s' do
    let(:company) { Company.new(valid_params) }
    let(:user1) do
      User.new('id' => 1, 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com', 'company_id' => 1,
               'email_status' => true, 'active_status' => true, 'tokens' => 0)
    end
    let(:user2) do
      User.new('id' => 2, 'first_name' => 'Jane', 'last_name' => 'Smith', 'email' => 'jane@example.com', 'company_id' => 1,
               'email_status' => true, 'active_status' => false, 'tokens' => 0)
    end

    before do
      company.add_user(user1)
      company.add_user(user2)
    end

    it 'returns string representation of users' do
      expect(company.users_to_s).to include(user1.to_s)
    end

    it 'does not include inactive users' do
      expect(company.users_to_s).not_to include(user2.to_s)
    end
  end

  describe '#total_top_up' do
    let(:company) { Company.new(valid_params) }
    let(:user1) do
      User.new('id' => 1, 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com', 'company_id' => 1,
               'email_status' => true, 'active_status' => true, 'tokens' => 0)
    end
    let(:user2) do
      User.new('id' => 2, 'first_name' => 'Jane', 'last_name' => 'Smith', 'email' => 'jane@example.com', 'company_id' => 1,
               'email_status' => true, 'active_status' => true, 'tokens' => 0)
    end

    before do
      company.add_user(user1)
      company.add_user(user2)
    end

    it 'calculates total top-up amount' do
      expect(company.total_top_up).to eq("    Total amount of top ups for #{company.name}: 200\n")
    end
  end
end
