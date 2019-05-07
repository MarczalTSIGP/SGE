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
        expect(page).to have_content(document.title)
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
        fill_in 'document_title', with: attributes[:title]
        all('div[contenteditable]')[0].set(attributes[:description])
        all('div[contenteditable]')[1].set(attributes[:activity])
        find(:css, 'select', match: :first).select user.name
        find(:css, 'div.document_users_documents_function input').set(Faker::Lorem.word)
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
        expect(page).to have_content(I18n.t('errors.messages.blank'), count: 5)
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
    let(:attributes) { build(:document) }

    before do
      visit edit_admin_document_path(document)
    end

    context 'with valid fields' do
      it 'update' do
        choose 'document_kind_certified'
        fill_in 'document_title', with: attributes[:title]
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
        fill_in 'document_title', with: ''
        all('div[contenteditable]')[0].set('').send_keys(:enter)
        all('div[contenteditable]')[0].send_keys(:backspace).send_keys(:backspace)
        all('div[contenteditable]')[1].set('').send_keys(:enter)
        all('div[contenteditable]')[1].send_keys(:backspace).send_keys(:backspace)
        find('a[partial="users_document_fields"]').click
        find('a[data-association="users_document"]').click
        click_button('Atualizar Documento')
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.blank'), count: 5)
      end
    end
  end

  describe '#destroy' do
    let!(:d) { create(:document) }
    let!(:dc) { create(:document, :request_signature) }

    before do
      visit admin_documents_path
    end

    it 'document' do
      click_on_link(admin_document_path(d), method: :delete)
      expect(page).to have_flash(:success, text: I18n.t('flash.actions.destroy.m',
                                                        model: model_name))
      expect_page_not_have_in('table tbody', d.users.each(&:name))
    end

    it 'document unless it is unsigned' do
      click_on_link(admin_document_path(dc), method: :delete)
      expect(page).to have_flash(:warning,
                                 text: I18n.t('flash.actions.request_signature.destroy'))
      expect(page).to have_content(dc.users.each(&:name).delete("[\]"))
    end
  end

  describe '#request_signature' do
    let!(:d) { create(:document) }
    let!(:drs) { create(:document, :request_signature) }

    before do
      logout(:user)
    end

    it 'request successfully' do
      login_as(d.users_documents[0].user, scope: :user)
      visit admin_documents_path
      click_on_link(admin_put_documents_request_signature_path(d), method: :put)
      expect(page).to have_flash(:success, text: I18n.t('flash.actions.request_signature.t'))
    end

    it 'already have request' do
      login_as(drs.users_documents[0].user, scope: :user)
      visit admin_documents_path
      click_on_link(admin_put_documents_request_signature_path(drs), method: :put)
      expect(page).to have_flash(:warning, text: I18n.t('flash.actions.request_signature.f'))
    end

    it 'not allowed' do
      login_as(admin, scope: :user)
      visit admin_documents_path
      click_on_link(admin_put_documents_request_signature_path(d), method: :put)
      expect(page).to have_flash(:warning,
                                 text: I18n.t('flash.actions.request_signature.signature'))
    end

    it 'view has request' do
      login_as(drs.users_documents[0].user, scope: :user)
      visit admin_documents_path
      expect(page).to have_css('a span', class: 'nav-unread')
      visit(admin_users_documents_subscriptions_path)
      expect(page).to have_content(drs.title)
      expect(page).to have_content(I18n.t("enums.kinds.#{drs.kind}"))
    end

    it 'does not have request' do
      login_as(d.users_documents[0].user, scope: :user)
      visit admin_documents_path
      expect(page).to have_css('a i', class: 'fe fe-bell')
      visit(admin_users_documents_subscriptions_path)
      expect(page).to have_flash(:info,
                                 text: I18n.t('flash.actions.sign.empty.m',
                                              model: I18n.t('activerecord.models.document.one')))
    end
  end

  describe '#subscriptions' do
    let!(:d) { create(:document) }
    let!(:drs) { create(:document, :request_signature) }

    before do
      logout(:user)
      login_as(drs.users_documents[0].user, scope: :user)
      visit(admin_users_documents_subscriptions_path)
    end

    it 'not document' do
      login_as(d.users_documents[0].user, scope: :user)
      visit(admin_users_documents_subscriptions_path)
      expect(page).to have_flash(:info,
                                 text: I18n.t('flash.actions.sign.empty.m',
                                              model: I18n.t('activerecord.models.document.one')))
    end

    it 'document parcipants', js: true do
      login_as(drs.users_documents[0].user, scope: :user)
      visit(admin_users_documents_subscriptions_path)
      link = "a[href='#{'#' + drs.title.titleize.delete(' ')}']"
      find(link).click
      expect(page).to have_content('Participantes')
      expect(page).to have_content(drs.users.each(&:name).delete("[\]"))
    end
  end

  describe '#auth' do
    let!(:drs) { create(:document, :request_signature) }

    before do
      logout(:user)
    end

    it 'success' do
      login_as(drs.users_documents[0].user, scope: :user)
      visit(admin_user_documents_sign_path(drs))
      expect(page).to have_content("Assinar #{drs.title}")
      expect(page).to have_current_path(admin_user_documents_sign_path(drs))
      fill_in id: 'document_login', with: drs.users_documents[0].user.username
      fill_in id: 'document_password', with: '123456'
      submit_form
      expect(page).to have_flash(:success,
                                 text: I18n.t('flash.actions.sign.valid.m',
                                              model: I18n.t('activerecord.models.document.one')))
    end

    it 'password invalid' do
      login_as(drs.users_documents[0].user, scope: :user)
      visit(admin_user_documents_sign_path(drs))
      fill_in id: 'document_login', with: drs.users_documents[0].user.username
      fill_in id: 'document_password', with: 'abcdef'
      submit_form
      expect(page).to have_flash(:warning,
                                 text: I18n.t('flash.actions.sign.invalid.m',
                                              model: I18n.t('activerecord.models.document.one')))
    end

    it 'login invalid' do
      login_as(drs.users_documents[0].user, scope: :user)
      visit(admin_user_documents_sign_path(drs))
      fill_in id: 'document_login', with: 'abc1232'
      fill_in id: 'document_password', with: '123456'
      submit_form
      expect(page).to have_flash(:warning,
                                 text: I18n.t('flash.actions.sign.invalid.m',
                                              model: I18n.t('activerecord.models.document.one')))
    end

    it 'outher user' do
      login_as(drs.users_documents[0].user, scope: :user)
      visit(admin_user_documents_sign_path(drs))
      fill_in id: 'document_login', with: user2.username
      fill_in id: 'document_password', with: '123456'
      submit_form
      expect(page).to have_flash(:warning,
                                 text: I18n.t('flash.actions.sign.invalid.m',
                                              model: I18n.t('activerecord.models.document.one')))
    end
  end
end
