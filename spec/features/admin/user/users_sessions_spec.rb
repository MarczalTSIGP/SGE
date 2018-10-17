require 'rails_helper'

RSpec.feature "Admin::User::UsersSessions", type: :feature do
  let!(:user) {create(:user)}
  let!(:user_inactive) {create(:user, :inactive)}

  describe '#create' do
    before(:each) do
      visit new_user_session_path
    end

    context 'with valid user' do

      it "login by username" do
        fill_in id: "user_login", with: user.username
        fill_in id: "user_password", with: user.password

        submit_form

        expect(current_path).to eq(admin_root_path)
      end

      it "login by email" do
        fill_in id: "user_login", with: user.email
        fill_in id: "user_password", with: user.password

        submit_form

        expect(current_path).to eq(admin_root_path)
      end
    end

    context 'with invalid user' do
      it "not login by username" do
        fill_in id: "user_login", with: "test2"
        fill_in id: "user_password", with: "123456"

        submit_form

        expect(page).to have_text(I18n.t('devise.failure.invalid',
                                         authentication_keys: 'Login'))
        expect(current_path).to eq(new_user_session_path)
      end

      it "not login by email" do
        fill_in id: "user_login", with: "test2@utfpr.edu.br"
        fill_in id: "user_password", with: "123456"

        submit_form

        expect(page).to have_text(I18n.t('devise.login.title'))
        expect(current_path).to eq(new_user_session_path)
      end
    end

    context 'with inactive user' do
      it 'not login by username' do
        fill_in id: "user_login", with: user_inactive.username
        fill_in id: "user_password", with: user_inactive.password

        submit_form

        expect(page).to have_text(I18n.t('devise.failure.locked'))
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end
end
