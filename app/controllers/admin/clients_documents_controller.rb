class Admin::ClientsDocumentsController < Admin::BaseController
  before_action :load_clients, only: [:new, :create, :edit]
  before_action :load_clients_index, only: [:new, :create, :edit, :update]

  def new
    document = Document.find(params[:document_id])
    @clients_documents = document.clients_documents.build
    @clients_documents.participant_hours_fields = ClientsDocument.hash_participants(params[:document_id])
  end

  def create
    document = Document.find(params[:document_id])
    @clients_documents = document.clients_documents.create(clients_document_params)
    if @clients_documents.save
      flash[:success] = t('flash.actions.create.m',
                          model: t('activerecord.models.clients_document.one'))
      redirect_to new_admin_document_clients_document_path(params[:document_id])
    else
      flash.now[:error] = t('flash.actions.errors')
      render :new
    end
  end

  def edit
    document = Document.find(params[:document_id])
    @clients_documents = document.clients_documents.find(params[:id])
  end

  def update
    document = Document.find(params[:document_id])
    @clients_documents = document.clients_documents.find(params[:id])
    if @clients_documents.update(clients_document_params)
      flash[:success] = t('flash.actions.update.m',
                          model: t('activerecord.models.clients_document.one'))

      redirect_to new_admin_document_clients_document_path(params[:document_id])
    else
      flash.now[:error] = t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    document = Document.find(params[:document_id])
    client_document = document.clients_documents.find(params[:id])
    if client_document.destroy
      flash[:success] = I18n.t('flash.actions.destroy.m',
                               model: t('activerecord.models.clients_document.one'))
    else
      flash.now[:error] = t('flash.actions.errors')
    end
    redirect_to new_admin_document_clients_document_path(params[:document_id])
  end

  private


  def clients_document_params
    params.require(:clients_document).permit(:id, :client_id, :document_id,
                                             participant_hours_fields: {})
  end

  def load_clients
    @clients = Client.order(name: :asc)
  end

  def load_clients_index
    @clients_document_show = ClientsDocument.where(document_id: params[:document_id]).order(created_at: :desc)
  end
end
