require 'rails_helper'

RSpec.feature "Admin::User::Registrations", type: :feature do

  let (:user_admin) {create(:user_admin)}
  let (:user_active) {create(:user)}

  scenario "Create new User valid" do

    sign_in user_admin

    visit new_user_registration_path


    fill_in id: "user_name", with: "Lorival"
    fill_in id: "user_password", with: "123456"
    fill_in id: "user_password_confirmation", with: "123456"
    fill_in id: "user_cpf", with: "29510867411"
    fill_in id: "user_registration_number", with: "123"
    fill_in id: "user_email", with: "lorival"

    check ("user_active")

    find('input[name="commit"]').click

    expect(page).to have_text("Usuário")
    expect(current_path).to eq(admin_users_disabled_path)
  end

  scenario "Create new User invalid" do

    sign_in user_admin

    visit new_user_registration_path

    fill_in id: "user_name", with: "Lorival"
    fill_in id: "user_password", with: "123456"
    fill_in id: "user_password_confirmation", with: "123456"
    fill_in id: "user_cpf", with: "12345678901"
    fill_in id: "user_registration_number", with: "123456"
    fill_in id: "user_email", with: "lorival@gmail.com"

    check ("user_active")

    find('input[name="commit"]').click

    expect(page).to have_text("Sign up")
    expect(page).to have_text("CPF inválido")
    expect(current_path).to eq(user_registration_path)

  end


  scenario "Create new User blank" do
    sign_in user_admin

    visit new_user_registration_path


    fill_in id: "user_name", with: ""
    fill_in id: "user_password", with: ""
    fill_in id: "user_password_confirmation", with: ""
    fill_in id: "user_cpf", with: ""
    fill_in id: "user_registration_number", with: ""
    fill_in id: "user_email", with: ""

    check ("user_active")

    find('input[name="commit"]').click

    expect(page).to have_text("Sign up")
    expect(page).to have_text("não pode ficar em branco", count: 4)

    expect(current_path).to eq(user_registration_path)

  end

  scenario "Create new user without permission" do
    sign_in user_active

    visit new_user_registration_path


    expect(page).to have_text("Admin")

    expect(current_path).to eq(admin_root_path)

  end

end
