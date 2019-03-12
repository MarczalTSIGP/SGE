require 'rails_helper'

RSpec.describe 'Admin::Document', type: :feature do
  let(:model_name) { I18n.t('activerecord.models.document.one') }
  let(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let(:client) { create_list(:client, 2).sample }

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
        expect(page).to have_content(I18n.t("enums.kinds.#{document.kind}"))
        expect(page).to have_content(document.created_at.strftime('%d-%m-%Y'))
        expect(page).to have_content(document.users.each(&:name).delete("[\]"))
        expect(page).to have_link(href: edit_admin_document_path(document))
        expect(page).to have_link(href: admin_document_path(document))
        destroy_link = "a[href='#{admin_document_path(document)}'][data-method='delete']"
        expect(page).to have_css(destroy_link)
      end
    end

    it 'search documents' do
      visit admin_documents_search_path(document.first.description)

      expect(page).to have_content(I18n.t("enums.kinds.#{document.first.kind}"))
      expect(page).to have_content(document.first.created_at.strftime('%d-%m-%Y'))
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
      expect(page).to have_content('República Federativa do Brasil')
      expect(page).to have_content('Ministério da Educação')
      expect(page).to have_content('Universidade Tecnológica Federal do Paraná')
      expect(page).to have_content(I18n.t("enums.kinds.#{document.kind}"))
      expect(page).to have_content(document.description)
      expect(page).to have_content(document.activity)
      document.users_documents.each do |user|
        expect(page).to have_content(user.user.name)
        expect(page).to have_content(user.function)
      end
    end
  end

  describe '#create', js: true do
    let(:attributes) { build(:document) }

    before do
      visit new_admin_document_path
    end

    context 'with valid fields' do
      it 'create recommendation' do
        choose 'document_kind_certified'
        function = Faker::Lorem.word
        all('div[contenteditable]')[0].set(attributes[:description])
        all('div[contenteditable]')[1].set(attributes[:activity])
        find(:css, 'select', match: :first).select user.name
        find(:css, 'div.document_users_documents_function input').set(function)
        click_button('Criar Documento')
        expect(page).to have_current_path(admin_documents_path)
        expect(page).to have_flash(:success, text: I18n.t('flash.actions.create.m',
                                                          model: model_name))
      end
    end

    context 'with invalid fields' do
      it 'show blank errors' do
        click_button('Criar Documento')
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.blank'), count: 4)
      end
      it 'type is not included in the list' do
        click_button('Criar Documento')
        expect(page).to have_current_path(admin_documents_path)
        expect(page).to have_content I18n.t('errors.messages.inclusion'), count: 1
      end
    end
  end

  describe 'preview' do
    context '#create', js: true do
      let(:attributes) { build(:document) }

      before do
        visit new_admin_document_path
      end

      it 'preview  document' do
        function = Faker::Lorem.word
        all('div[contenteditable]')[0].set(attributes.description)
        all('div[contenteditable]')[1].set(attributes.activity)
        find(:css, 'select', match: :first).select user.name
        find(:css, 'div.document_users_documents_function input').set(function)
        click_button I18n.t('helpers.buttons.preview')
        expect(page).to have_content(attributes.description)
        expect(page).to have_content(attributes.activity)
        expect(page).to have_content(user.name)
        expect(page).to have_content(function.humanize)
      end

      it 'preview document certificate' do
        choose 'document_kind_certified'
        click_button I18n.t('helpers.buttons.preview')
        expect(page).to have_content(I18n.t('enums.kinds.certified').upcase, count: 1)
      end

      it 'preview document declaration' do
        choose 'document_kind_declaration'
        click_button I18n.t('helpers.buttons.preview')
        expect(page).to have_content(I18n.t('enums.kinds.declaration').upcase, count: 1)
      end
    end

    context '#update', js: true do
      let!(:document) { create(:document) }

      before do
        visit edit_admin_document_path(document)
      end

      it 'preview document' do
        click_button I18n.t('helpers.buttons.preview')
        expect(page).to have_content('República Federativa do Brasil')
        expect(page).to have_content('Ministério da Educação')
        expect(page).to have_content('Universidade Tecnológica Federal do Paraná')
        expect(page).to have_content(I18n.t("enums.kinds.#{document.kind}").upcase, count: 1)
        expect(page).to have_content(document.description)
        expect(page).to have_content(document.activity)
        expect(page).to have_content(document.users.each(&:name).delete("[\]"))
        expect(page).to have_content(document.users_documents[0].function.humanize)
      end

      it 'preview  certificate' do
        choose 'document_kind_certified'
        click_button I18n.t('helpers.buttons.preview')
        expect(page).to have_content(I18n.t('enums.kinds.certified').upcase, count: 1)
      end

      it 'preview declaration' do
        choose 'document_kind_declaration'
        click_button I18n.t('helpers.buttons.preview')
        expect(page).to have_content(I18n.t('enums.kinds.declaration').upcase, count: 1)
      end
    end
  end

  describe '#update', js: true do
    let(:document) { create(:document) }

    before do
      visit edit_admin_document_path(document)
    end

    context 'with valid fields' do
      it 'update' do
        attributes = attributes_for(:document)
        choose 'document_kind_certified'
        all('div[contenteditable]')[0].set(attributes[:description])
        all('div[contenteditable]')[1].set(attributes[:activity])
        fill_in 'document_users_documents_attributes_0_function', with: user2.name
        fill_in 'document_users_documents_attributes_0_function', with: Faker::Lorem.word
        click_button('Atualizar Documento')
        expect(page).to have_current_path(admin_documents_path)
        expect(page).to have_flash(:success, text: I18n.t('flash.actions.update.m',
                                                          model: model_name))
      end
    end

    context 'with invalid field' do
      it 'show blank errors' do
        all('div[contenteditable]')[0].set('').send_keys(:backspace)
        all('div[contenteditable]')[1].set('').send_keys(:backspace)
        find('a[partial="users_document_fields"]').click
        find('a[data-associations="users_documents"]').click
        click_button('Atualizar Documento')
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.blank'), count: 4)
      end
    end
  end

  describe '#destroy' do
    it 'document' do
      d = create(:document)

      visit admin_documents_path
      click_on_link(admin_document_path(d), method: :delete)
      expect(page).to have_flash(:success, text: I18n.t('flash.actions.destroy.m',
                                                        model: model_name))
      expect_page_not_have_in('table tbody', d.users.each(&:name))
    end

    it 'document unless it is unsigned' do
      dc = create(:document, :subscription)
      visit admin_documents_path
      click_on_link(admin_document_path(dc), method: :delete)
      expect(page).to have_selector('div.alert.alert-warning',
                                    text: 'Não é possível remover documento com assinatura!')
      expect(page).to have_content(dc.users.each(&:name).delete("[\]"))
    end
  end
end
