require 'rails_helper'

RSpec.describe "admin/users/registrations/index", type: :view do

  before(:each) do
    @user_admin = create(:user_admin)
    @user_active = create(:user)
    @user_inactive = create(:user_inactive)

    assign(:users, [@user_inactive, @user_active, @user_admin])
  end

  it "render user view index" do
    render

    expect(rendered).to match @user_admin.name
    expect(rendered).to match @user_inactive.name
    expect(rendered).to match @user_active.name

    expect(rendered).to have_link(href: admin_user_registration_index_path)
    expect(rendered).to have_link(href: new_admin_user_registration_path)
    expect(rendered).to have_selector('input',
                                      count: 1, visible: true)
    expect(rendered).to have_selector('button', count: 1)

  end

end
