source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Loading Envs
gem 'dotenv'
gem 'redis'
# Postgres
gem 'pg'
# Twilio
gem 'twilio-ruby', '~> 5.7.2'
# Use authy for phone verification
gem 'authy'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Authentication
gem 'bcrypt', '~> 3.1', '>= 3.1.11'
# UserImage Attachments
gem 'paperclip', '~> 5.1'
# AWS sdk for image storage
gem 'aws-sdk', '~> 2.3.0'
# custom JSON serializer(Used for ProfileImage)
gem 'active_model_serializers'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :test do
  # Test gems
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
  gem 'database_cleaner', '~> 1.6', '>= 1.6.2'
end

group :development do
  # speeds up development by keeping application running in background.https://github.com/rails/spring
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
