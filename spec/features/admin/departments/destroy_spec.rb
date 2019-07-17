require 'rails_helper'

describe 'Admin::Departments::destroy', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:resource_name) { Department.model_name.human }
  let!(:department) { create(:department) }

  before(:each) do
    login_as(admin, scope: :user)
    visit admin_departments_path
  end

  describe '#destroy' do
    context 'when department is destroyed' do
      it 'show success message' do
        click_on_link(admin_department_path(department), method: :delete)

        expect(page).to have_current_path admin_departments_path
        expect(page).to have_flash(:success, text: flash_msg('destroy.m'))
        within('table tbody') do
          expect(page).not_to have_content(department.initials)
        end
      end
    end
  end
end
