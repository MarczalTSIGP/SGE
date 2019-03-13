require 'rails_helper'

RSpec.describe 'Admin::ClientDocument', type: :feature do
  let(:model_name) { I18n.t('activerecord.models.clients_document.one') }
  let(:admin) { create(:user, :admin) }
  let!(:client) { create(:client) }

  before do
    login_as(admin, scope: :user)
  end

  describe '#index' do
    let!(:document) { create_list(:document, 3, :participant) }

    before do
      visit new_admin_document_clients_document_path(document.first)
    end

    it 'show all particpants with options' do
      ClientsDocument.all.each do |cd|
        expect(page).to have_content(cd.client.name)
        expect(page).to have_content(cd.participant_hours_fields)
      end
    end
  end

  describe '#create' do
    let(:document) { create(:document) }

    before do
      visit new_admin_document_clients_document_path(document)
    end

    context 'with valid fields' do
      it 'create recommendation' do
        hour = rand(1..10)
        find(:css, 'select', match: :first).select client.name
        find(:css, 'input.numeric.integer').set(hour)
        submit_form
        expect(page).to have_flash(:success, text: I18n.t('flash.actions.create.m',
                                                          model: model_name))
      end
    end

    context 'with invalid fields' do
      it 'show blank errors' do
        submit_form
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.blank'), count: 2)
      end
      it 'show unique error' do
        hour = rand(1..10)
        find(:css, 'select', match: :first).select client.name
        find(:css, 'input.numeric.integer').set(hour)
        submit_form
        find(:css, 'select', match: :first).select client.name
        find(:css, 'input.numeric.integer').set(hour)
        submit_form
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.taken'))
      end
    end
  end

  describe '#update' do
    let!(:document_p) { create(:document, :participant) }
    let!(:client2) { create(:client) }

    before do
      visit edit_admin_document_clients_document_path(document_p, document_p.clients_documents.ids)
    end

    context 'with valid fields' do
      it 'create recommendation' do
        find(:css, 'select', match: :first).select client2.name
        fill_in 'clients_document_participant_hours_fields_hora_1', with: 11
        submit_form
        expect(page).to have_flash(:success, text: I18n.t('flash.actions.update.m',
                                                          model: model_name))
        expect(page).to have_content(client2.name)
        expect(page).to have_content('hora_1' => '11')
      end
    end

    context 'with invalid field' do
      it 'show blank errors' do
        find(:css, 'select', match: :first).select ''
        fill_in 'clients_document_participant_hours_fields_hora_1', with: ''
        submit_form
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.blank'), count: 2)
      end
      it 'show unique error' do
        hour = rand(1..10)
        find(:css, 'select', match: :first).select client.name
        find(:css, 'input.numeric.integer').set(hour)
        submit_form
        find(:css, 'select', match: :first).select client.name
        find(:css, 'input.numeric.integer').set(hour)
        submit_form
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect(page).to have_content(I18n.t('errors.messages.taken'))
      end
    end
  end

  describe '#destroy' do
    let!(:document_p) { create(:document, :participant) }

    it 'oarticipante' do
      visit new_admin_document_clients_document_path(document_p)
      click_on_link(admin_document_clients_document_path(document_p,
                                                         document_p.clients_documents.ids),
                    method: :delete)
      expect(page).to have_flash(:success, text: I18n.t('flash.actions.destroy.m',
                                                        model: model_name))
    end
  end
end
