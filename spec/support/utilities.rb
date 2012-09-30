# below line is required for 'full_title' function to work in spec
include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: 'Invalid')
  end
end

def sign_in(user)
  visit root_path
  fill_in "header_signin_email",    with: user.email
  fill_in "header_signin_password", with: user.password
  click_button "static_home_signin"
  # Sign in when not using Capybara.
  cookies[:remember_token] = user.remember_token
end