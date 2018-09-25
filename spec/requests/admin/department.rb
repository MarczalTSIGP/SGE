require 'rails_helper'

RSpec.describe Department, :type => :request do

  describe '#index' do

  end

  describe '#create' do
    context 'when all parameters sent are valid' do

      let(:valid_params) {{department: attributes_for(:department)}}
      let(:create_department) {post '/admin/departments', params: valid_params}

      before(:each) do
        create_department
      end

      it 'returns the success message after create' do
        expect(flash[:success]).to eq 'Departamento criado com sucesso.'
      end

      it 'redirect to show' do
        expect(response).to redirect_to(admin_department_path(Department.last))
      end

      it 'increase the number of departments' do
        expect(Department.count).to eq(1)
      end
    end

    context 'when one or more parameters sent are invalid' do
      let(:invalid_params) {{department: {name: ' ', initials: 'aa', phone: '000'}}}
      let(:create_department) {post '/admin/departments', params: invalid_params}

      before(:each) do
        create_department
      end

      it 'returns the error message after do not create' do
        expect(flash[:error]).to eq 'Existem dados incorretos! Por favor verifique.'
      end

      it 'render messages for invalid values' do
        assert_select "div.department_name" do
          assert_select "div.invalid-feedback", text: 'Nome é obrigatório, por favor insira um.'
        end
        assert_select "div.department_initials" do
          assert_select "div.invalid-feedback", text: 'Sigla é muito curto (mínimo: 3 caracteres)'
        end
        assert_select "div.department_local" do
          assert_select "div.invalid-feedback", text: 'Local não pode ficar em branco'
        end
        assert_select "div.department_phone" do
          assert_select "div.invalid-feedback", text: 'Telefone é muito curto (mínimo: 10 caracteres)'
        end
        assert_select "div.department_email" do
          assert_select "div.invalid-feedback",
                        text: 'Email do Departamento não pode ficar em branco e Email do Departamento não é válido'
        end
      end

      it 'do not increase the number of departments' do
        expect(Department.count).to eq(0)
      end
    end
  end

  describe '#update' do
    context 'when all parameters  sent are valid' do

      let(:departmentb) { create(:department) }
      let(:department_params) { { department_id: departmentb.id } }
      let(:update_department) { put admin_department_path(department_params) }

      before(:each) do
        update_department
      end

      it 'change value initials' do
        expect(Department.last.initials).to eq('DIRPPG')
      end

      # it 'returns the success message after update' do
      #   expect(flash[:success]).to eq 'Departamento alterado com sucesso.'
      # end
      #
      # it 'redirect to show' do
      #   expect(response).to redirect_to(admin_department_path(Department.last))
      # end
      #
      # it 'do not increase the number of departments' do
      #   expect(Department.count).to eq(1)
      # end

    end
  end
end