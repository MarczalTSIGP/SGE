require 'rails_helper'

RSpec.describe Admin::DepartmentsController, type: :routing do
  describe 'search routes' do
    it 'no terms got to #index' do
      expect(get: '/admin/departments').to route_to('admin/departments#index')
    end
    it 'no terms and pagination go to #index' do
      expect(get: '/admin/departments/page/2').to route_to('admin/departments#index', page: '2')
    end
    it 'with terms go to #index' do
      expect(get: '/admin/departments/search/').to route_to('admin/departments#index')
      expect(get: '/admin/departments/search/name').to route_to('admin/departments#index',
                                                                term: 'name')
    end
    it 'with term and pagination go to #index' do
      expect(get: '/admin/departments/search/name/page/2').to route_to('admin/departments#index',
                                                                       term: 'name', page: '2')
    end
  end
end
