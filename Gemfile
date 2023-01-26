source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.10'

# need a rake version less than 11 so that rspec-rails works
gem 'rake', '< 11.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

group :development, :test do
  gem 'rspec-rails'
  gem 'pry'
end

group :test do
  gem 'json_expressions'
  gem 'factory_girl_rails', require: false
end
