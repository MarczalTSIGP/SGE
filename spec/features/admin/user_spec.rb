require 'rails_helper'

RSpec.describe 'Admin::User', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:model_name) { I18n.t('activerecord.models.user.one') }
  let(:model_plural_name) { I18n.t('activerecord.models.user.other') }

  before(:each) do
    login_as(admin, scope: :user)
  end

  describe '#create' do
    before(:each) do
      visit new_admin_user_path
    end

    context 'with valid fields' do
      let(:params) { attributes_for_form(:user) }
      let(:index_table_data) do
        [params[:user_name], "#{params[:user_username]}@utfpr.edu.br",
         I18n.t('helpers.boolean.user.true')]
      end

      it 'create recommendation' do
        fill_and_submit_form('.simple_form', params) do
          check('user_active')
        end

        expect(page).to have_current_path(admin_users_path)
        expect(page).to have_text(model_plural_name)
        expect(page).to have_flash(:success, text: I18n.t('flash.actions.create.m',
                                                          model: model_name))

        within('table tbody') do
          expect(page).to have_contents(index_table_data)
        end
      end
    end

    context 'with invalid fields' do
      it 'show blank errors' do
        submit_form

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.blank'), count: 3)
      end

      it 'show taken errors' do
        fill_in id: 'user_username', with: admin.username
        fill_in id: 'user_registration_number', with: admin.registration_number
        fill_in id: 'user_cpf', with: admin.cpf
        submit_form

        expect(page).to have_flash('danger', text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.taken'), count: 3)
        expect(page).to have_current_path(admin_users_path)
      end

      it 'show invalid errors' do
        fill_in id: 'user_cpf', with: '1234567'
        fill_in id: 'user_alternative_email', with: 'adsf@adsf.asd@'
        submit_form

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.invalid'), count: 3)
      end
    end
  end

  describe '#update' do
    let(:user) { create(:user) }

    before(:each) do
      visit edit_admin_user_path(user)
    end

    context 'with fields filled' do
      it 'with correct values' do
        expect(page).to have_field 'user_name', with: user.name
        expect(page).to have_field 'user_username', with: user.username
        expect(page).to have_field 'user_registration_number', with: user.registration_number
        expect(page).to have_field 'user_cpf', with: user.cpf
      end
    end

    context 'with valid fields' do
      let(:params) { attributes_for_form(:user) }
      let(:index_table_data) do
        [params[:user_name], "#{params[:user_username]}@utfpr.edu.br",
         I18n.t('helpers.boolean.user.true')]
      end

      it 'update recommendation' do
        fill_and_submit_form('.simple_form', params) do
          uncheck('user_active')
        end

        expect(page).to have_current_path(admin_users_path)
        expect(page).to have_flash(:success, text: I18n.t('flash.actions.update.m',
                                                          model: model_name))

        within('table tbody') do
          expect(page).to have_contents(index_table_data)
        end
      end
    end

    context 'with invalid fields' do
      it 'show blank errors' do
        fill_in id: 'user_name', with: ''
        fill_in id: 'user_username', with: ''
        fill_in id: 'user_alternative_email', with: ''
        fill_in id: 'user_registration_number', with: ''
        fill_in id: 'user_cpf', with: ''
        submit_form

        expect(page).to have_current_path(admin_user_path(user))
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.blank'), count: 3)
      end

      it 'show taken errors' do
        fill_in id: 'user_username', with: admin.username
        fill_in id: 'user_cpf', with: admin.cpf
        fill_in id: 'user_registration_number', with: admin.registration_number
        submit_form

        expect(page).to have_current_path(admin_user_path(user))
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.taken'), count: 3)
      end

      it 'show invalid errors' do
        fill_in id: 'user_cpf', with: '12314124124124'
        fill_in id: 'user_alternative_email', with: '@Asdf@ASD'
        submit_form

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.invalid'), count: 2)
      end
    end
  end

  describe '#index' do
    let!(:user) { create(:user) }
    let!(:user_inactive) { create(:user, :inactive) }

    before(:each) do
      visit admin_users_path
    end

    it 'show all users with options' do
      User.all.each do |user|
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.email)
        expect(page).to have_content(I18n.t("helpers.boolean.user.#{user.active?}"))

        href = user.active? ? admin_user_disable_path(user) : admin_user_active_path(user)
        expect(page).to have_link(href: href)

        expect(page).to have_link(href: edit_admin_user_path(user))
        expect(page).to have_link(href: admin_user_path(user))
      end
    end

    it 'search users' do
      visit admin_users_search_path(user.name)

      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(I18n.t('helpers.boolean.user.true'))
      expect(page).to have_current_path(admin_users_search_path(user.name))
    end

    it 'activating user' do
      expect(page).to have_content(I18n.t('helpers.boolean.user.false'), 1)

      click_on_link(admin_user_active_path(user_inactive), method: :put)

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content(I18n.t('helpers.boolean.user.true'), 2)
      expect(page).to have_flash(:success, text: I18n.t('flash.actions.active.m',
                                                        model: model_name))
    end

    it 'disable user' do
      expect(page).to have_content(I18n.t('helpers.boolean.user.false'), 1)

      click_on_link(admin_user_disable_path(user), method: :put)

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content(I18n.t('helpers.boolean.user.false'), 2)
      expect(page).to have_flash(:success, text: I18n.t('flash.actions.disable.m',
                                                        model: model_name))
    end
  end

  describe '#show' do
    let!(:user) { create(:user) }

    before(:each) do
      visit admin_user_path(user)
    end

    it 'show user' do
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.username)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.alternative_email)
      expect(page).to have_content(user.registration_number)
      expect(page).to have_content(user.cpf.pretty)
      expect(page).to have_content(I18n.t("helpers.boolean.user.#{user.active?}"))
    end
  end
end
