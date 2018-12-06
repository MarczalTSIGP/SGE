require 'rails_helper'

RSpec.describe Admin::Users::RegistrationsHelper, type: :helper do
  describe '#link_to_active_disable' do
    let(:user) { create(:user) }

    it 'disable case' do
      disable_link = '<a class="icon" title="Desativar Usuário" data-toggle="tooltip"'
      disable_link +=   ' data-placement="top" rel="nofollow" data-method="put"'
      disable_link +=   " href=\"/admin/users/disable/#{user.id}\">"
      disable_link +=   '<i class="fe fe-user-x"></i>'
      disable_link += '</a>'

      expect(helper.link_to_active_disable(user)).to eql(disable_link)
    end

    it 'enable case' do
      user.active = false
      enable_link = '<a class="icon" title="Ativar Usuário" data-toggle="tooltip"'
      enable_link +=   ' data-placement="top" rel="nofollow" data-method="put"'
      enable_link +=   " href=\"/admin/users/active/#{user.id}\">"
      enable_link +=   '<i class="fe fe-user-check"></i>'
      enable_link += '</a>'

      expect(helper.link_to_active_disable(user)).to eql(enable_link)
    end
  end
end
