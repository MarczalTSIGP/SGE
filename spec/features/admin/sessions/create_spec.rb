require 'rails_helper'

RSpec.describe 'Admin::Devise::UsersSessions', type: :feature do
  let!(:user) { create(:user, :admin) }
  let!(:user_staff) { create(:user) }
  let!(:user_inactive) { create(:user, :inactive) }

  describe '#create' do
    before(:each) do
      visit new_user_session_path
    end

    context 'with valid user' do
      it 'login by username' do
        fill_in id: 'user_login', with: user.username
        fill_in id: 'user_password', with: user.password

        submit_form

        expect(page).to have_current_path(admin_root_path)
        expect(page).to have_flash(:info, text: devise_signed_in_msg)
      end

      it 'login by email' do
        fill_in id: 'user_login', with: user.email
        fill_in id: 'user_password', with: user.password

        submit_form

        expect(page).to have_current_path(admin_root_path)
        expect(page).to have_flash(:info, text: devise_signed_in_msg)
      end
    end

    context 'with invalid user' do
      it 'not login by username' do
        fill_in id: 'user_login', with: 'test2'
        fill_in id: 'user_password', with: '123'
        submit_form

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_flash(:warning, text: devise_invalid_sign_in_msg)
      end

      it 'not login by email' do
        fill_in id: 'user_login', with: 'test2@utfpr.edu.br'
        fill_in id: 'user_password', with: '1235'
        submit_form

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_flash(:warning, text: devise_invalid_sign_in_msg)
      end
    end

    context 'with inactive user' do
      it 'not login by username' do
        fill_in id: 'user_login', with: user_inactive.username
        fill_in id: 'user_password', with: user_inactive.password
        submit_form

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_flash(:info, text: devise_user_locked_msg)
      end
    end

    context 'with valid user staff' do
      it 'login by username' do
        fill_in id: 'user_login', with: user_staff.username
        fill_in id: 'user_password', with: user_staff.password

        submit_form

        expect(page).to have_current_path(staff_root_path)
        expect(page).to have_flash(:info, text: devise_signed_in_msg)
      end

      it 'login by email' do
        fill_in id: 'user_login', with: user_staff.email
        fill_in id: 'user_password', with: user_staff.password

        submit_form

        expect(page).to have_current_path(staff_root_path)
        expect(page).to have_flash(:info, text: devise_signed_in_msg)
      end
    end
  end
end
