require 'rails_helper'

RSpec.feature "Admin::User::Registrations", type: :feature do

  before(:each) do
    @user_admin = create(:user_admin)
    @user_active = create(:user)
    @user_inactive = create(:user_inactive)
  end

  scenario "Create new User valid" do
    sign_in @user_admin

    visit new_admin_user_registration_path

    fill_in id: "user_name", with: "Lorival"
    fill_in id: "user_username", with: "lorival"
    fill_in id: "user_cpf", with: "29510867411"
    fill_in id: "user_registration_number", with: "123"
    check ("user_active")
    find('input[name="commit"]').click

    expect(page).to have_text("Registrar Usuário")
    expect(current_path).to eq(new_admin_user_registration_path)
  end

  scenario "Create new User invalid" do
    sign_in @user_admin

    visit new_admin_user_registration_path

    fill_in id: "user_name", with: "Lorival"
    fill_in id: "user_cpf", with: "12345678901"
    fill_in id: "user_registration_number", with: "123456"
    fill_in id: "user_username", with: "lorival@gmail.com"
    check ("user_active")
    find('input[name="commit"]').click

    expect(page).to have_text("Registrar Usuário")
    expect(current_path).to eq(admin_user_registration_index_path)
  end

  scenario "Create new User blank" do
    sign_in @user_admin

    visit new_admin_user_registration_path

    fill_in id: "user_name", with: ""
    fill_in id: "user_cpf", with: ""
    fill_in id: "user_registration_number", with: ""
    fill_in id: "user_username", with: ""
    check ("user_active")
    find('input[name="commit"]').click

    expect(page).to have_text("Registrar Usuário")
    expect(page).to have_text("não pode ficar em branco", count: 4)
    expect(current_path).to eq(admin_user_registration_index_path)
  end

  scenario "Create new user without permission" do
    sign_in @user_active

    visit new_admin_user_registration_path

    expect(page).to have_text("Admin")
    expect(current_path).to eq(admin_root_path)
  end

  scenario "Admin update user" do
    sign_in @user_admin

    visit edit_admin_user_registration_path(@user_inactive)

    expect(page).to have_text("Editar " + @user_inactive.name.humanize)
    fill_in id: "user_alternative_email", with: "abc123@alternativo.com"
    check ("user_active")
    find('input[name="commit"]').click

    expect(page).to have_text("Usuários")
    expect(page).to have_text("Ativo", count: 3)
    expect(current_path).to eq(admin_user_registration_index_path)

    visit edit_admin_user_registration_path(@user_active)

    expect(page).to have_text("Editar " + @user_active.name.humanize)
    uncheck ("user_active")

    find('input[name="commit"]').click
    expect(page).to have_text("Usuários")
    expect(page).to have_text("Ativo", count: 2)
    expect(current_path).to eq(admin_user_registration_index_path)
  end

  scenario "update profile information" do
    sign_in @user_active

    visit edit_admin_user_registration_path(@user_active)

    expect(page).to have_text("Editar " + @user_active.name.humanize)
    fill_in id: "user_alternative_email", with: "abc123@alternativo.com"
    find('input[name="commit"]').click

    expect(page).to have_text("Usuário editado com sucesso!")
    expect(current_path).to eq(admin_root_path)
  end

  scenario "update profile information for another user without permission" do
    sign_in @user_active

    visit edit_admin_user_registration_path(@user_inactive)

    expect(page).to have_text("Admin")
    expect(current_path).to eq(admin_root_path)
  end

  scenario "search user by name " do
    sign_in @user_admin

    visit admin_user_registration_index_path

    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present

    fill_in id: "search", with: @user_active.name
    click_button ("Buscar")

    expect(@user_active).to be_present
  end

  scenario "search user by email institutional" do
    sign_in @user_admin

    visit admin_user_registration_index_path

    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present

    fill_in id: "search", with: @user_active.email
    click_button ("Buscar")

    expect(@user_active).to be_present
  end

  scenario "search user by email alternative" do
    sign_in @user_admin

    visit admin_user_registration_index_path

    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present

    fill_in id: "search", with: @user_active.alternative_email
    click_button ("Buscar")

    expect(@user_active).to be_present
  end

  scenario "search for nonexistent user" do
    sign_in @user_admin

    visit admin_user_registration_index_path

    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present

    fill_in id: "search", with: "xxxxxx"
    click_button ("Buscar")

    expect(page).to have_text("Nenhum registro encontrado")
  end

  scenario "clear search" do
    sign_in @user_admin

    visit admin_user_registration_index_path

    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present

    fill_in id: "search", with: "xxxxxx"
    click_button ("Buscar")

    expect(page).to have_text("Nenhum registro encontrado")

    click_link ("Limpar")

    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present
  end


  scenario "disable user" do
    sign_in @user_admin

    visit admin_user_registration_index_path

    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present
    expect(page).to have_text('Ativo', count: 2)
    expect(page).to have_text('Desativado', count: 1)
    find("a[href='#{admin_user_disable_path(@user_active)}']").click

    expect(page).to have_text('Desativado', count: 3)
    expect(page).to have_text('Ativo', count: 1)
    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present
    expect(page).to have_text('Usuário')
    expect(current_path).to eq(admin_user_registration_index_path)
  end


  scenario "active user" do
    sign_in @user_admin

    visit admin_user_registration_index_path

    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present
    expect(page).to have_text('Desativado', count: 1)
    expect(page).to have_text('Ativo', count: 2)
    find("a[href='#{admin_user_active_path(@user_inactive)}']").click

    expect(page).to have_text('Desativado', count: 0)
    expect(page).to have_text('Ativo', count: 3)
    expect(@user_admin).to be_present
    expect(@user_active).to be_present
    expect(@user_inactive).to be_present

    expect(page).to have_text("Usuário")
    expect(current_path).to eq(admin_user_registration_index_path)
  end

  scenario "user without permission" do
    sign_in @user_active

    visit admin_user_registration_index_path

    expect(page).to have_text("Admin")
    expect(current_path).to eq(admin_root_path)
  end
end
