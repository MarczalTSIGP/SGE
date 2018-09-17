require 'rails_helper'

RSpec.feature "Admin::User::UsersSessions", type: :feature do
  before(:each) do
    create(:user)
    create(:user_inactive)
  end

  scenario "User new session valid using username" do
    visit new_user_session_path

    fill_in id: "user_login", with: "test"
    fill_in id: "user_password", with: "123456"

    find('input[name="commit"]').click

    expect(page).to have_text("Admin")
    expect(current_path).to eq(admin_root_path)
  end

  scenario "User new session invalid using username" do
    visit new_user_session_path

    fill_in id: "user_login", with: "test2"
    fill_in id: "user_password", with: "123456"

    find('input[name="commit"]').click

    expect(page).to have_text("Log in")
    expect(current_path).to eq(new_user_session_path)
  end

  scenario "User new session valid using email" do
    visit new_user_session_path

    fill_in id: "user_login", with: "test@utfpr.edu.br"
    fill_in id: "user_password", with: "123456"

    find('input[name="commit"]').click

    expect(page).to have_text("Admin")
    expect(current_path).to eq(admin_root_path)
  end

  scenario "User new session invalid using email" do
    visit new_user_session_path

    fill_in id: "user_login", with: "test2@utfpr.edu.br"
    fill_in id: "user_password", with: "123456"

    find('input[name="commit"]').click

    expect(page).to have_text("Log in")
    expect(current_path).to eq(new_user_session_path)
  end
end
