require 'rails_helper'

RSpec.feature "Admin::User::Disableds", type: :feature do

  before(:each) do
    @user_admin = create(:user_admin)
    @user_active = create(:user)
    @user_inactive = create(:user_inactive)
  end

  scenario "disable user" do

    sign_in @user_admin

    visit admin_users_disabled_path

    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present
    expect(page).to have_text('Desativado', count: 1)
    expect(page).to have_text('Ativo', count: 2)

    find("a[href='#{admin_user_destroy_path(@user_active)}']").click


    expect(page).to have_text('Desativado', count: 2)
    expect(page).to have_text('Ativo', count: 1)
    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present

    expect(page).to have_text("Usuário")
    expect(current_path).to eq(admin_users_disabled_path)
  end


  scenario "active user" do

    sign_in @user_admin

    visit admin_users_disabled_path

    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present
    expect(page).to have_text('Desativado', count: 1)
    expect(page).to have_text('Ativo', count: 2)

    find("a[href='#{admin_user_destroy_path(@user_inactive)}']").click

    expect(page).to have_text('Desativado', count: 0)
    expect(page).to have_text('Ativo', count: 3)
    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present

    expect(page).to have_text("Usuário")
    expect(current_path).to eq(admin_users_disabled_path)
  end

  scenario "user without permission" do

    sign_in @user_active

    visit admin_users_disabled_path

    expect(page).to have_text("Admin")
    expect(current_path).to eq(admin_root_path)
  end
end
