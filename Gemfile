source 'https://rubygems.org'
ruby '1.9.3'
gem 'rails', '3.2.14'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'zurb-foundation'
gem 'google-webfonts'
gem 'jquery_datepicker'
gem 'jquery-rails', '~> 2.3.0'
gem 'foundation-icons-rails'
gem 'animatecss'
gem 'wunderground'
gem 'rails-timeago', '~> 2.0'
gem 'gon'
gem 'cells'
gem 'devise'
gem 'figaro'
gem 'mongoid'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'twitter'
gem 'geocoder'
gem 'resque'
gem 'resque-scheduler'
gem 'tweetstream'
gem 'god'
gem 'capistrano', '~> 2.15'
group :development do
  gem 'rvm-capistrano'
  gem 'capistrano-unicorn', :require => false
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'quiet_assets'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'thin'
end
group :production do
  gem 'unicorn'
  gem 'therubyracer'
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require=>false
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'launchy'
  gem 'mongoid-rspec'
end
