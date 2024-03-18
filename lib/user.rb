# frozen_string_literal: true

require 'active_model'

# Class representing a User
class User
  include ActiveModel::Validations

  # Attributes accessible for read and write
  attr_accessor :id,
                :first_name,
                :last_name,
                :email,
                :company_id,
                :email_status,
                :active_status,
                :tokens

  # Validations for User attributes
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i, on: :create }
  validates_presence_of :id,
                        :first_name,
                        :last_name,
                        :email,
                        :company_id,
                        :active_status,
                        :tokens

  # Initializes a new User instance with optional parameters
  #
  # @param params [Hash] Parameters for user initialization
  # @option params [Integer] 'id' User ID
  # @option params [String] 'first_name' User's first name
  # @option params [String] 'last_name' User's last name
  # @option params [String] 'email' User's email address
  # @option params [Integer] 'company_id' ID of the company the user belongs to
  # @option params [Boolean] 'email_status' User's email status
  # @option params [Boolean] 'active_status' User's active status
  # @option params [Integer] 'tokens' User's token balance
  def initialize(params = {})
    @id = params['id']
    @first_name = params['first_name']
    @last_name = params['last_name']
    @email = params['email']
    @company_id = params['company_id']
    @email_status = params['email_status']
    @active_status = params['active_status']
    @tokens = params['tokens']
    validate!
  end

  # Validates the User object
  #
  # Raises:
  # ArgumentError: If any required attribute is nil or if the email is malformed
  def validate!
    raise ArgumentError, "Id can't be nil" if id.nil?
    raise ArgumentError, "First name can't be nil" if first_name.nil?
    raise ArgumentError, "Last name can't be nil" if last_name.nil?
    raise ArgumentError, "Email can't be nil" if email.nil?
    raise ArgumentError, 'Malformed email' unless /\A[\w+\-.]+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i.match?(email)
    raise ArgumentError, "Top up can't be nil" if company_id.nil?
    raise ArgumentError, "Email status can't be nil" if email_status.nil?
    raise ArgumentError, "Active status can't be nil" if active_status.nil?
    raise ArgumentError, "Tokens can't be nil" if tokens.nil?
  end

  # Returns a string representation of the User
  #
  # @return [String] String representation of the User
  def to_s
    "#{last_name}, #{first_name}, #{email}\n"
  end

  # Adds tokens to the user's token balance
  #
  # @param amount [Integer] Amount of tokens to add
  # @return [String] Information about the previous and new token balances
  def add_token(amount)
    prev_tokens = tokens
    @tokens += amount
    "Previous Token Balance, #{prev_tokens}\n      New Token Balance #{tokens}\n"
  end
end
