require 'rails_helper'

RSpec.describe "department", :type => :request do

  it "displays the show after successful create department" do
    visit new_admin_department_path
    fill_in "Nome", with: "Diretoria Relações Empresarias"
    fill_in "Sigla", with: "DEREMP"
    fill_in "Local", with: "p16"
    fill_in "Telefone", with: "1234567890"
    fill_in "Email do Departamento", with: "deremp@utfpr.edu.br"
    fill_in "Responsável pelo Departamento", with: "Monielly"
    click_button "Criar Departamento"

    expect(page).to have_selector(".name", text: "Diretoria Relações Empresarias")
  end

end