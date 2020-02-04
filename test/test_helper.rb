ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "support/test_password_helper"

module SignInHelper
  def sign_in_as_default
    # post login_url(user: { username: 'test1', password: 'Thisistest1' })
    post login_url(user: { username: users(:one).username, password: 'Thisistest1' })
  end
end

class ActiveSupport::TestCase
  include TestPasswordHelper
  include SignInHelper
  
  ActiveRecord::FixtureSet.context_class.send :include, TestPasswordHelper

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
