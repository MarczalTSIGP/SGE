require 'rails_helper'

RSpec.feature "Admin::User::UsersSessions", type: :feature do
  let!(:user) {create(:user)}
  let!(:user_inactive) {create(:user_inactive)}

  describe '#create' do
    context 'with valid user' do

      it "by username" do
        visit new_user_session_path

        fill_in id: "user_login", with: "test"
        fill_in id: "user_password", with: "123456"

        find('input[name="commit"]').click

        expect(page).to have_text("Dashboard")
        expect(current_path).to eq(admin_root_path)
      end
      it "by email" do
        visit new_user_session_path

        fill_in id: "user_login", with: "test@utfpr.edu.br"
        fill_in id: "user_password", with: "123456"

        find('input[name="commit"]').click

        expect(page).to have_text("Dashboard")
        expect(current_path).to eq(admin_root_path)
      end
    end
    context 'with invalid user' do
      it "by username" do
        visit new_user_session_path

        fill_in id: "user_login", with: "test2"
        fill_in id: "user_password", with: "123456"

        find('input[name="commit"]').click

        expect(page).to have_text("Faça login na sua conta")
        expect(current_path).to eq(new_user_session_path)
      end


      it "by email" do
        visit new_user_session_path

        fill_in id: "user_login", with: "test2@utfpr.edu.br"
        fill_in id: "user_password", with: "123456"

        find('input[name="commit"]').click

        expect(page).to have_text("Faça login na sua conta")
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end
end