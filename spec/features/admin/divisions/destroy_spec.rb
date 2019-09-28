require 'rails_helper'

describe 'Admin::Divisions::destroy', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:resource_name) { Division.model_name.human }
  let!(:division) { create(:division) }

  before(:each) do
    login_as(admin, scope: :user)
    visit admin_department_divisions_path(division.department_id)
  end

  describe '#destroy' do
    context 'when department is destroyed' do
      it 'show success message' do
        department = division.department_id
        click_on_link(admin_department_division_path(division.department_id,
                                                     division.id),
                      method: :delete)

        expect(page).to have_current_path admin_department_divisions_path(department)
        expect(page).to have_flash(:success, text: flash_msg('destroy.m'))
        within('table tbody') do
          expect(page).not_to have_content(division.name)
        end
      end
    end
  end
end
