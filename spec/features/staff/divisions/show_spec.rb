require 'rails_helper'

describe 'Staff::Divisions::show', type: :feature do
  let(:staff) { create(:user) }
  let(:department_user) { create(:department_users, user: staff) }
  let!(:division) { create(:division, department_id: department_user.department_id) }

  before(:each) do
    login_as(staff, scope: :user)
  end

  context 'with data' do
    it 'showed ' do
      visit staff_department_division_path(division.department_id, division)

      expect(page).to have_content(division.department.initials)
      expect(page).to have_content(division.name)
      expect(page).to have_content(division.description)
      division.division_users do |member|
        expect(page).to have_content(member.name)
      end
    end
  end

  context 'with links' do
    before(:each) do
      visit staff_department_division_path(division.department_id, division)
    end

    it do
      expect(page).to have_link(I18n.t('views.links.back'),
                                href: staff_department_divisions_path(division.department_id))
    end
  end
end
