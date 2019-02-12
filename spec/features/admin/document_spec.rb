require 'rails_helper'

RSpec.describe 'Admin::Document', type: :feature do
  let(:model_name) { I18n.t('activerecord.models.document.one') }
  let(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:client) { create_list(:client, 2).sample }

  before do
    login_as(admin, scope: :user)
  end

  describe '#index' do
    let!(:document) { create_list(:document, 2) }


    before do
      visit admin_documents_path
    end

    it 'show all documents with options' do
      Document.all.each do |document|
        expect(page).to have_content(
                            I18n.t("enums.kinds.#{document.kind}"))
        expect(page).to have_content(
                            document.created_at.strftime("%d-%m-%Y"))
        document.users.each do |user|
          expect(page).to have_content(user.name)
        end

        expect(page).to have_link(href: edit_admin_document_path(document))
        expect(page).to have_link(href: admin_document_path(document))
        destroy_link = "a[href='#{admin_document_path(document)}'][data-method='delete']"
        expect(page).to have_css(destroy_link)
      end
    end


    it 'search documents' do
      visit admin_documents_search_path(document.first.description)

      expect(page).to have_content(I18n.t("enums.kinds.#{document.first.kind}"))
      expect(page).to have_content(document.first.created_at.strftime("%d-%m-%Y"))
      document.first.users.each do |user|
        expect(page).to have_content(user.name)
      end
      expect(page).to have_current_path(admin_documents_search_path(document.first.description))
    end
  end

  describe '#show' do
    let!(:document) { create(:document) }

    before do
      visit admin_document_path(document)
    end

    it 'show document' do
      expect(page).to have_content("República Federativa do Brasil")
      expect(page).to have_content("Ministério da Educação")
      expect(page).to have_content("Universidade Tecnológica Federal do Paraná")
      expect(page).to have_content(I18n.t("enums.kinds.#{document.kind}").upcase)
      expect(page).to have_content(document.description)
      expect(page).to have_content(document.activity)
      document.users.each { |user|
        expect(page).to have_content(user.name)
      }
    end
  end

  describe '#create' do
    before do
      visit new_admin_document_path
    end

    context 'with valid fields' do
      let(:params) { attributes_for_form(:document) }

      it 'create recommendation' do
        attributes = attributes_for(:document)
        choose 'document_kind_certified'
        fill_in 'document_description', with: attributes[:description]
        fill_in 'document_activity', with: attributes[:activity]
        select admin.name, from: 'document_user_ids'
        attach_file 'document_participants', FileSpecHelper.csv.path
        submit_form

        expect(page).to have_current_path(admin_documents_path)
        expect(page).to have_flash(:success, text: I18n.t('flash.actions.create.m',
                                                          model: model_name))
      end

      context 'with invalid fields' do
        it 'show blank errors' do
          submit_form

          expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
          expect(page).to have_content(I18n.t('errors.messages.blank'), count: 3)
        end
        it 'type is not included in the list' do
          submit_form
          expect(page).to have_current_path(admin_documents_path)
          expect(page).to have_content I18n.t('errors.messages.inclusion'), count: 1
        end

        it 'preview certificate document' do
          attributes = attributes_for(:document)
          choose 'document_kind_certified'
          fill_in 'document_description', with: attributes[:description]
          fill_in 'document_activity', with: attributes[:activity]
          select admin.name, from: 'document_user_ids'
          attach_file 'document_participants', FileSpecHelper.csv.path
          click_button I18n.t('helpers.buttons.preview')

          expect(page).to have_content("República Federativa do Brasil")
          expect(page).to have_content("Ministério da Educação")
          expect(page).to have_content("Universidade Tecnológica Federal do Paraná")
          expect(page).to have_content(I18n.t("enums.kinds.certified").upcase)
          expect(page).to have_content(attributes[:description])
          expect(page).to have_content(attributes[:activity])
          expect(page).to have_content(admin.name)
        end

        it 'preview document declaration' do
          attributes = attributes_for(:document)
          choose 'document_kind_declaration'
          fill_in 'document_description', with: attributes[:description]
          fill_in 'document_activity', with: attributes[:activity]
          select admin.name, from: 'document_user_ids'
          attach_file 'document_participants', FileSpecHelper.csv.path
          click_button I18n.t('helpers.buttons.preview')

          expect(page).to have_content("República Federativa do Brasil")
          expect(page).to have_content("Ministério da Educação")
          expect(page).to have_content("Universidade Tecnológica Federal do Paraná")
          expect(page).to have_content(I18n.t("enums.kinds.declaration").upcase)
          expect(page).to have_content(attributes[:description])
          expect(page).to have_content(attributes[:activity])
          expect(page).to have_content(admin.name)
        end
      end
    end
  end

  describe '#update' do
    let(:document) { create(:document) }
    before do
      visit edit_admin_document_path(document)
    end

    context 'with fields filled' do
      it 'with correct values' do
        choose 'document_kind_certified'
        expect(page).to have_field 'document_description', with: document.description
        expect(page).to have_field 'document_activity', with: document.activity
        expect(page).to have_select 'document_user_ids',
                                    selected: document.users.map(&:name)
      end
    end

    context 'with valid fields' do
      it 'update document' do
        attributes = attributes_for(:document)
        choose 'document_kind_certified'
        fill_in 'document_description', with: attributes[:description]
        fill_in 'document_activity', with: attributes[:activity]
        select admin.name, from: 'document_user_ids'
        attach_file 'document_participants', FileSpecHelper.csv.path
        submit_form

        expect(page).to have_current_path(admin_documents_path)
        expect(page).to have_flash(:success, text: I18n.t('flash.actions.update.m',
                                                          model: model_name))
      end

      context 'with invalid fields' do
        it 'show blank errors' do
          fill_in 'document_description', with: ''
          fill_in 'document_activity', with: ''

          submit_form

          expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
          expect(page).to have_content(I18n.t('errors.messages.blank'), count: 2)
        end
      end
    end
  end

  describe '#destroy' do
    it 'document' do
      d = create(:document, :without_subscription)
      visit admin_documents_path
      click_on_link(admin_document_path(d), method: :delete)
      expect(page).to have_flash(:success, text: I18n.t('flash.actions.destroy.m',
                                                        model: model_name))
      expect_page_not_have_in('table tbody', d.users.each { |user| user.name })
    end

    it 'document unless it is unsigned' do
      dc = create(:document)
      visit admin_documents_path
      click_on_link(admin_document_path(dc), method: :delete)
      expect(page).to have_selector('div.alert.alert-warning',
                                    text: 'Não é possível remover documento com assinatura!')
      expect(page).to have_content(dc.users.map(&:name).delete("[\]"))
    end
  end
end

