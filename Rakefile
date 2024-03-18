# frozen_string_literal: true

require_relative './lib/challenge'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'json'

desc 'Run Specs'
begin
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  # no rspec available
end

desc 'Run Linter'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--auto-correct-all']
end

desc 'Read JSON files from command line'
task :read_json_files do
  files = ENV['FILES'] || []
  files = files.split(',') unless files.empty?

  if files.empty?
    puts 'No files provided. Usage: rake read_json_files FILES=file1.json,file2.json'
  else
    users_json = []
    companies_json = []

    files.each do |file|
      json_data = File.read(file)
      parsed_data = JSON.parse(json_data)

      if File.basename(file) == 'users.json'
        users_json.concat(parsed_data)
      elsif File.basename(file) == 'companies.json'
        companies_json.concat(parsed_data)
      else
        puts "Unknown file type: #{file}"
      end
    rescue Errno::ENOENT
      puts "File not found: #{file}"
    rescue JSON::ParserError => e
      puts "Invalid JSON format in file: #{file} - #{e.message}"
    end

    process_files(users_json, companies_json)
  end
end
