require 'rails_helper'

RSpec.describe "admin/users/registrations/new", type: :view do
  it "render user view " do
    @user = User.new

    render

    expect(rendered).to have_text('Registrar Usuário')
    expect(rendered).to have_selector('form', id: 'new_user')
    expect(rendered).to have_selector('label', count: 6)
    expect(rendered).to have_selector('input',
                                      count: 7, visible: true)
  end
end
