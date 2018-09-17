require 'rails_helper'

RSpec.describe "admin/users/registrations/index", type: :view do

  before(:each) do
    @user_admin = create(:user_admin)
    @user_active = create(:user)
    @user_inactive = create(:user_inactive)

    assign(:users, [@user_inactive, @user_active, @user_admin])
  end

  it "render user view " do
    render
    expect(rendered).to match @user_admin.name
    expect(rendered).to match @user_inactive.name
    expect(rendered).to match @user_active.name
  end
end
