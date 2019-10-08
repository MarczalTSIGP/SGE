require 'rails_helper'

describe 'Admins::Divisions::show', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:division) { create(:division) }

  before(:each) do
    login_as(admin, scope: :user)
  end

  context 'with data' do
    it 'showed ' do
      visit admin_department_division_path(division.department_id, division)

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
      visit admin_department_division_path(division.department_id, division)
    end

    it do
      expect(page).to have_link(I18n.t('views.links.back'),
                                href: admin_department_divisions_path(division.department_id))
    end
  end
end
