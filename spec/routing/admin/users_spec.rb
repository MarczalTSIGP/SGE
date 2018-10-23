require 'rails_helper'

RSpec.describe Admin::UsersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/users").to route_to("admin/users#index")
      expect(get: "/admin/users/page/2").to route_to("admin/users#index", page: '2')
      expect(get: "/admin/users/search/").to route_to("admin/users#index")
      expect(get: "/admin/users/search/name").to route_to("admin/users#index",
                                                          term: 'name')
      expect(get: "/admin/users/search/name/page/2").to route_to("admin/users#index",
                                                                 term: 'name', page: '2')
    end
  end
end