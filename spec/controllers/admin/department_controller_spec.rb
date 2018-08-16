require 'rails_helper'

RSpec.describe Admin::DepartmentController, type: :controller do

  let(:departmentb) { create(:departments) }
  let(:department_params) { {department_id: departmentb.id} }
  let(:valid_attributes) do
    department_params.merge({departments: attributes_for(:departments) })
  end
  let(:invalid_attributes) do
    department_params.merge({departments: attributes_for(:departments, name: " ") })
  end

  describe "GET #index" do
    it "populates an array of departments"
    it "renders the :index view"
  end

  describe "GET #show" do
    it "assigns the requested departments to @department"
    it "renders the :show template"
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: department_params
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new department" do
        expect {
          post :create, params: valid_attributes
        }.to change(Department, :count).by(1)
      end

      it "redirects to the created department" do
        post :create, params: valid_attributes
        expect(response).to redirect_to(admin_department_path(departmentb))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: invalid_attributes
        expect(response).to be_success
      end
    end
  end
end
