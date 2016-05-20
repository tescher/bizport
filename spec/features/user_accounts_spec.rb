require 'rails_helper'

describe "going through the signup flow", :type => :feature do

  it "creates an account, logs the user in, and redirects them back to where they were before" do
    new_user_email = Faker::Internet.email
    start_location = '/start' # should always redirect to the first "step" page

    visit start_location
    expect(page).to have_content "Log In"

    expect(page.location).to eq('/start')
    expect(User.last.email).to eq(new_user_email)
  end

end
