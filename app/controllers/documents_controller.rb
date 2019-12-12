class DocumentsController < ApplicationController
  def index; end

  def search
    @document_client = DocumentClient.includes(document: [document_users: :user])
                                     .find_by(key_code: params[:code])
    @document = @document_client.document
    render layout: '/layouts/print'
  end
end
