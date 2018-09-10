require 'rails_helper'

RSpec.feature "UsersRegistrations", type: :feature do
  scenario "Create new User valid" do
    visit new_user_registration_path


    fill_in id: "user_name", with: "Lorival"
    fill_in id: "user_password", with: "123456"
    fill_in id: "user_password_confirmation", with: "123456"
    fill_in id: "user_cpf", with: "16590783268"
    fill_in id: "user_registration_number", with: "123456"
    fill_in id: "user_email", with: "lorival@utfpr.edu.br"

    check ("user_active")

    find('input[name="commit"]').click

    expect(page).to have_text("Home#index")
    expect(current_path).to eq(root_path)
  end

  scenario "Create new User invalid" do
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
    expect(page).to have_text("Email não institucional")
    expect(page).to have_text("CPF inválido")
    expect(current_path).to eq(user_registration_path)

  end


  scenario "Create new User blank" do
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
    expect(page).to have_text("não pode ficar em branco", count: 5)

    expect(current_path).to eq(user_registration_path)

  end
end
