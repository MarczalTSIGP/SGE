require 'rails_helper'

RSpec.describe Admin::UsersController, type: :routing do
  describe 'search routes' do
    it 'no terms got to #index' do
      expect(get: '/admin/users').to route_to('admin/users#index')
    end
    it 'no terms and pagination go to #index' do
      expect(get: '/admin/users/page/2').to route_to('admin/users#index', page: '2')
    end
    it 'with terms go to #index' do
      expect(get: '/admin/users/search/').to route_to('admin/users#index')
      expect(get: '/admin/users/search/name').to route_to('admin/users#index',
                                                          term: 'name')
    end
    it 'with term and pagination go to #index' do
      expect(get: '/admin/users/search/name/page/2').to route_to('admin/users#index',
                                                                 term: 'name', page: '2')
    end
  end
end
