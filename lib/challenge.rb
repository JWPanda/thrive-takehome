# frozen_string_literal: true

require 'json'
require_relative '../lib/user'
require_relative '../lib/company'

# Processes the JSON data of users and companies, adds users to their respective companies,
# and outputs the processed data.
#
# @param users_json [Array<Hash>] Array of user data in JSON format
# @param companies_json [Array<Hash>] Array of company data in JSON format
def process_files(users_json, companies_json)
  # Convert JSON data to objects
  begin
    # Attempt to create objects
    users = users_json.map! { |user| User.new(user) }
  rescue ArgumentError => e
    # If an error occurs, open the file in append mode and write the error message along with timestamp
    File.open('./output/error_logs.txt', 'w') do |file|
      file.write "Error: #{e.message}"
    end
    puts 'Malformed users.json file'
    raise
  end

  begin
    # Attempt to create objects
    companies = companies_json.map! { |company| Company.new(company) }
  rescue ArgumentError => e
    # If an error occurs, open the file in append mode and write the error message along with timestamp
    File.open('./output/error_logs.txt', 'w') do |file|
      file.write "Error: #{e.message}"
    end
    puts 'Malformed companies.json file'
    raise
  end

  # Add users to their respective companies
  add_users_to_companies(users, companies)

  # Output the processed data
  output(companies)
end

private

# Adds users to their respective companies.
#
# @param users [Array<User>] Array of User objects
# @param companies [Array<Company>] Array of Company objects
def add_users_to_companies(users, companies)
  companies.each do |company|
    # Filter users belonging to the current company
    company_users = users.filter { |user| user.company_id == company.id }
    company_users.each { |user| company.add_user(user) }
  end
end

# Outputs the processed data for each company.
#
# @param companies [Array<Company>] Array of Company objects
def output(companies)
  # Create a string to add to
  output_str = String.new

  companies.each do |company|
    # Construct output string with company details, users, and total top up
    output_str << "\n"
    output_str << company.to_s
    output_str << company.users_to_s
    output_str << company.total_top_up
  end

  # write data to file
  File.write('./output/output.txt', output_str)
end
