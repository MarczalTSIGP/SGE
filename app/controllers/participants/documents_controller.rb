class Participants::DocumentsController < Participants::BaseController

  def index
    @documents = Document.joins(:document_clients, :document_users)
                         .where(request_signature: true,
                          document_clients: { cpf: current_client.cpf }).group(:id)
                         .where.not(id: DocumentUser.where(subscription: false)
                                    .pluck(:'document_users.document_id'))
                          .page(params[:page]).per(10)

    return unless @documents.empty?

    flash.now[:notice] = t('flash.actions.search.empty.m',
                           model: t('activerecord.models.document.one'))
  end

  def show
    @document = Document.includes(document_users: :user)
                        .joins(:document_clients, :document_users)
                        .find_by(id: params[:id],
                                 request_signature: true,
                                 document_clients: { cpf: current_client.cpf },
                                 document_users: { subscription: true })

    if @document.nil?
      flash.now[:notice] = t('flash.actions.search.empty.m',
                             model: t('activerecord.models.document.one'))
      redirect_to participants_documents_path
    else
      render layout: '/layouts/print'
    end
  end
end
