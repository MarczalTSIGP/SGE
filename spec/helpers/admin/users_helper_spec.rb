require 'rails_helper'

RSpec.describe Admin::UsersHelper, type: :helper do
  describe '#link_to_active_disable' do
    let(:user) { create(:user) }

    it 'disable case' do
      disable_link = '<a title="' + I18n.t('views.links.disable') + '" data-toggle="tooltip"'
      disable_link +=   ' rel="nofollow" data-method="put"'
      disable_link +=   " href=\"/admin/users/disable/#{user.id}\">"
      disable_link +=   '<i class="fas fa-user-lock icon"></i>'
      disable_link += '</a>'

      expect(helper.link_to_active_disable(user)).to eql(disable_link)
    end

    it 'enable case' do
      user.active = false
      enable_link = '<a title="' + I18n.t('views.links.active') + '" data-toggle="tooltip"'
      enable_link +=   ' rel="nofollow" data-method="put"'
      enable_link +=   " href=\"/admin/users/active/#{user.id}\">"
      enable_link +=   '<i class="fas fa-user-check icon"></i>'
      enable_link += '</a>'

      expect(helper.link_to_active_disable(user)).to eql(enable_link)
    end
  end
end
