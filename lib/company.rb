# frozen_string_literal: true

require 'active_model'

# Class representing a Company
class Company
  include ActiveModel::Validations

  # Attributes accessible for read and write
  attr_accessor :id, :name, :top_up, :email_status, :users

  # Validations for Company attributes
  validates_presence_of :id, :name, :top_up, :email_status

  # Initializes a new Company instance with optional parameters
  #
  # @param params [Hash] Parameters for company initialization
  # @option params [Integer] 'id' Company ID
  # @option params [String] 'name' Company name
  # @option params [Integer] 'top_up' Amount to top up
  # @option params [Boolean] 'email_status' Company's email status
  # @option params [Array<User>] 'users' Users belonging to the company
  def initialize(params = {})
    @id = params['id']
    @name = params['name']
    @top_up = params['top_up']
    @email_status = params['email_status']
    @users = []
    validate!
  end

  # Validates the Company object
  #
  # Raises:
  # ArgumentError: If any required attribute is nil or if the email is malformed
  def validate!
    raise ArgumentError, "Id can't be blank" if id.nil?
    raise ArgumentError, "Name can't be blank" if name.nil?
    raise ArgumentError, "Top up can't be blank" if top_up.nil?
    raise ArgumentError, "Email status can't be blank" if email_status.nil?
  end

  # Returns a string representation of the Company
  #
  # @return [String] String representation of the Company
  def to_s
    "  Company Id: #{id}\n  Company Name: #{name}\n"
  end

  # Adds a user to the company
  #
  # @param user [User] User to be added
  def add_user(user)
    @users.append(user)
  end

  # Retrieves active users belonging to the company, sorted by last name
  #
  # @return [Array<User>] Active users sorted by last name
  def active_users
    users.filter(&:active_status).sort_by(&:last_name)
  end

  # Generates a string representation of users in the company who have been emailed and those who have not
  #
  # @return [String] String representation of users in the company
  def users_to_s
    users_emailed + users_not_emailed
  end

  # Generates a string representation of users in the company who have been emailed
  #
  # @return [String] String representation of users in the company who have been emailed
  def users_emailed
    str = String.new
    str << "  Users Emailed:\n"

    return str unless email_status

    active_users.each do |user|
      str << "    #{user}" if user.email_status
      str << "      #{user.add_token(top_up)}" if user.email_status
    end

    str
  end

  # Generates a string representation of users in the company who have not been emailed
  #
  # @return [String] String representation of users in the company who have not been emailed
  def users_not_emailed
    str = String.new
    str << "  Users Not Emailed:\n"

    if !email_status
      active_users.each do |user|
        str << "    #{user}"
        str << "      #{user.add_token(top_up)}"
      end
    else
      active_users.each do |user|
        str << "    #{user}" unless user.email_status
        str << "      #{user.add_token(top_up)}" unless user.email_status
      end
    end

    str
  end

  # Calculates the total amount of top ups for the company
  #
  # @return [String] Information about the total amount of top ups for the company
  def total_top_up
    total = active_users.length * top_up

    "    Total amount of top ups for #{name}: #{total}\n"
  end
end
