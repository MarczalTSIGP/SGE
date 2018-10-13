require 'rails_helper'

RSpec.feature "Admin::User", type: :feature do

  let(:admin) {create(:user_admin)}
  before(:each) do
    login_as(admin, scope: :user)
  end

  describe '#create' do

    before(:each) do
      visit new_admin_user_path
    end

    context 'with valid fields' do
      it 'create recommendation' do
        attributes = attributes_for(:user)
        fill_in id: 'user_name', with: attributes[:name]
        fill_in id: 'user_username', with: attributes[:username]
        fill_in id: 'user_registration_number', with: attributes[:registration_number]
        fill_in id: 'user_cpf', with: attributes[:cpf]
        check ('user_active')
        find('input[name="commit"]').click

        expect(current_path).to eq(admin_users_path)
        expect(page).to have_text("Usuários")
        expect(page).to have_selector('div.alert.alert-success',
                                      text: I18n.t('flash.actions.create.m',
                                                   model: I18n.t('activerecord.models.user.one')))

        within('table tbody') do
          expect(page).to have_content(attributes[:name])
          expect(page).to have_content(attributes[:email])
        end
      end

      context 'with invalid fields' do
        it 'show errors blank' do
          find('input[name="commit"]').click
          expect(page).to have_selector('div.alert.alert-danger',
                                        text: I18n.t('flash.actions.errors'))
          expect(page).to have_content(I18n.t('errors.messages.blank'), count: 4)
        end

        it 'show errors in use' do
          fill_in id: 'user_username', with: admin.username
          fill_in id: 'user_registration_number', with: admin.registration_number
          fill_in id: 'user_cpf', with: admin.cpf
          find('input[name="commit"]').click
          expect(page).to have_selector('div.alert.alert-danger',
                                        text: I18n.t('flash.actions.errors'))
          expect(page).to have_content("CPF " + I18n.t('errors.messages.taken'))
          expect(page).to have_content("Número de Registro " + I18n.t('errors.messages.taken'))
          expect(page).to have_content("Usuário institucional " + I18n.t('errors.messages.taken'))
          expect(current_path).to eq(admin_users_path)
        end

        it 'show errors invalid' do
          attributes = attributes_for(:user_invalid)
          fill_in id: 'user_cpf', with: attributes[:cpf]
          fill_in id: 'user_alternative_email', with: attributes[:alternative_email]
          find('input[name="commit"]').click
          expect(page).to have_selector('div.alert.alert-danger',
                                        text: I18n.t('flash.actions.errors'))
          expect(page).to have_content("CPF " + I18n.t('errors.messages.invalid'))
          expect(page).to have_content("Email Alternativo " + I18n.t('errors.messages.invalid'))
        end

      end
    end


  end

  describe '#update' do
    let(:user) {create (:user)}
    let!(:user_inactive) {create (:user_inactive)}

    before(:each) do
      visit edit_admin_user_path(user)
    end

    context 'fill fields' do
      it 'with correct values' do
        expect(page).to have_field 'user_name', with: user.name
        expect(page).to have_field 'user_username', with: user.username
        expect(page).to have_field 'user_registration_number', with: user.registration_number
        expect(page).to have_field 'user_cpf', with: user.cpf
      end
    end

    context 'with valid fields' do
      it 'update recommendation' do
        attributes = attributes_for(:user)
        fill_in id: 'user_name', with: attributes[:name]
        fill_in id: 'user_username', with: attributes[:username]
        fill_in id: 'user_alternative_email', with: attributes[:alternative_email]
        fill_in id: 'user_registration_number', with: attributes[:registration_number]
        fill_in id: 'user_cpf', with: attributes[:cpf]
        check ('user_active')
        find('input[name="commit"]').click

        expect(current_path).to eq(admin_users_path)

        expect(page).to have_text("Usuários")
        expect(page).to have_selector('div.alert.alert-success',
                                      text: I18n.t('flash.actions.update.m',
                                                   model: I18n.t('activerecord.models.user.one')))

        within('table tbody') do
          expect(page).to have_content(attributes[:name])
          expect(page).to have_content(attributes[:email])
        end
      end
    end

    context 'with invalid fields' do
      it 'show errors blank' do

        fill_in id: 'user_name', with: ''
        fill_in id: 'user_username', with: ''
        fill_in id: 'user_alternative_email', with: ''
        fill_in id: 'user_registration_number', with: ''
        fill_in id: 'user_cpf', with: ''
        find('input[name="commit"]').click
        expect(page).to have_selector('div.alert.alert-danger',
                                      text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.blank'), count: 4)
      end

      it 'show errors in use' do
        fill_in id: 'user_username', with: admin.username
        fill_in id: 'user_cpf', with: admin.cpf
        fill_in id: 'user_registration_number', with: admin.registration_number

        find('input[name="commit"]').click
        expect(page).to have_selector('div.alert.alert-danger',
                                      text: I18n.t('flash.actions.errors'))
        expect(page).to have_content("CPF " + I18n.t('errors.messages.taken'))
        expect(page).to have_content("Número de Registro " + I18n.t('errors.messages.taken'))
        expect(page).to have_content("Usuário institucional " + I18n.t('errors.messages.taken'))

        expect(current_path).to eq(admin_user_path(user))
      end

      it 'show errors invalid' do
        attributes = attributes_for(:user_invalid)
        fill_in id: 'user_cpf', with: attributes[:cpf]
        fill_in id: 'user_alternative_email', with: attributes[:alternative_email]
        find('input[name="commit"]').click
        expect(page).to have_selector('div.alert.alert-danger',
                                      text: I18n.t('flash.actions.errors'))
        expect(page).to have_content("CPF " + I18n.t('errors.messages.invalid'))
        expect(page).to have_content("Email Alternativo " + I18n.t('errors.messages.invalid'))
      end
    end
  end

  describe '#index' do
    let!(:user) {create(:user)}
    let!(:user_inactive) {create(:user_inactive)}

    before(:each) do
      visit admin_users_path
    end

    it 'show all users with options' do
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content("Ativo")
      expect(page).to have_link(href: admin_user_disable_path(user))
      expect(page).to have_link(href: edit_admin_user_path(user))
      expect(page).to have_link(href: admin_user_path(user))

      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content("Desativo")
      expect(page).to have_link(href: admin_user_active_path(user_inactive))
      expect(page).to have_link(href: edit_admin_user_path(user_inactive))
      expect(page).to have_link(href: admin_user_path(user_inactive))
    end

    it 'user search by url' do
      visit admin_users_search_path(user.name)
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content("Ativo")
      expect(current_path).to eq(admin_users_search_path(user.name))
    end

    # it 'user search' do
    #   options = Selenium::WebDriver::Chrome::Options.new
    #   options.add_argument('--ignore-certificate-errors')
    #   options.add_argument('--disable-popup-blocking')
    #   options.add_argument('--disable-translate')
    #   driver = Selenium::WebDriver.for :chrome, options: options
    #
    #   fill_in id: 'users_search_input', with: user.name
    #   driver.action.key_down(:enter)
    #   expect(page).to have_content(user.name)
    #   expect(page).to have_content(user.email)
    #   expect(page).to have_content("Ativo")
    #   expect(current_path).to eq(admin_users_search_path(user.name))
    # end

    it 'activating user' do
      expect(page).to have_content("Ativo", 1)
      active_link = "a[href='#{admin_user_active_path(user_inactive)}'][data-method='put']"
      find(active_link).click
      expect(page).to have_content("Ativo", 2)
      expect(page).to have_selector('div.alert.alert-success',
                                    text: I18n.t('flash.actions.active.m',
                                                 model: I18n.t('activerecord.models.user.one')))
      expect(current_path).to eq(admin_users_path)
    end

    it 'disable user' do
      expect(page).to have_content("Desativo", 1)
      disable_link = "a[href='#{admin_user_disable_path(user)}'][data-method='delete']"
      find(disable_link).click
      expect(page).to have_content("Desativo", 2)
      expect(page).to have_selector('div.alert.alert-success',
                                    text: I18n.t('flash.actions.disable.m',
                                                 model: I18n.t('activerecord.models.user.one')))
      expect(current_path).to eq(admin_users_path)
    end
  end

  describe '#show' do

    let!(:user) {create(:user)}


    before(:each) do
      visit admin_user_path(user)
    end

    it 'show user' do
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.username)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.alternative_email)
      expect(page).to have_content(user.registration_number)
      expect(page).to have_content(UserSpecHelper.mask_cpf(user.cpf))
      expect(page).to have_content(UserSpecHelper.translate_active(user))
    end
  end
end

