require 'rails_helper'

RSpec.describe "admin/users/registrations/edit", type: :view do
  before(:each) do
    @user_admin = create(:user_admin)
    @user_active = create(:user)
  end

  it "render user edit view admin" do
    assign(:user, @user_admin)
    sign_in @user_admin
    render
    expect(rendered).to have_text("Editar " + @user_admin.name.to_s.humanize)
    expect(rendered).to have_selector('form',
                                      id: 'edit_user_' + @user_admin.id.to_s)
    expect(rendered).to have_selector('label', count: 6)
    expect(rendered).to have_selector('input',
                                      count: 7, visible: true)

  end
  it "render user edit view" do
    assign(:user, @user_active)
    render
    expect(rendered).to have_text("Editar " + @user_active.name.to_s.humanize)
    expect(rendered).to have_selector('form',
                                      id: 'edit_user_' + @user_active.id.to_s)
    expect(rendered).to have_selector('label', count: 5)
    expect(rendered).to have_selector('input',
                                      count: 6, visible: true)
  end
end
