# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.
require 'cucumber/rails'
require 'capybara-screenshot/cucumber'

Capybara::Screenshot.autosave_on_failure = false
# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = "#{Rails.root}/tmp/csv"
  profile['browser.helperApps.neverAsk.saveToDisk'] = "text/csv" # content-type of file that will be downloaded
  Capybara::Selenium::Driver.new(app, :browser => :firefox, profile: profile)
end

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how 
# your application behaves in the production environment, where an error page will 
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false


# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     DatabaseCleaner.strategy = :truncation, {:except => %w[widgets]}
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation

require 'cucumber/rspec/doubles'
require 'rspec/rails'
require 'rspec/mocks'

# If you want to use a different mock framework than
# RSpec-Mocks - just set configure that accordingly
#
require 'rspec/core'
RSpec.configure do |c|
  c.mock_framework = :rspec
#  c.mock_framework = :mocha
#  c.mock_framework = :rr
#  c.mock_framework = :flexmock
end

#remove paperclip files 
module Paperclip::Interpolations 
  alias_method :org_attachment, :attachment 

  def attachment(att, style) 
    "CUKE#{ENV['TDDIUM_TID']}/" + org_attachment(att, style) 
  end 
end 

After do 
  dir = "#{Rails.root}/public/system/messages/CUKE#{ENV['TDDIUM_TID']}"
  FileUtils.rm_rf(dir)
end 



World(RSpec::Rails::Mocks, RSpec::Mocks::ExampleMethods)

