class Staff::DocumentClientsController < Staff::BaseController
  before_action :set_document
  before_action :set_division
  before_action :set_department
  before_action :set_document_client, only: [:edit, :update, :show, :destroy]
  before_action :request_signature?, except: [:new, :create]

  def index
    @document_clients = DocumentClient.where(document_id: params[:document_id])
                                      .page(params[:page])
                                      .search(params[:term])
  end

  def new
    @document_client = @doc.document_clients.build
    @document_client.information = ActiveSupport::JSON.decode @doc.variables
    @document_client.information = @document_client.information.map { |k, v| v }
  end

  def create
    @document_client = @doc.document_clients.build(params_document_client)
    @document_client.key_code = SecureRandom.urlsafe_base64(nil, false)
    if @document_client.save
      success_create_message
      redirect_to staff_department_division_document_document_clients_path(@dept.id, @div.id, @doc.id)
    else
      error_message
      render :new
    end
  end

  def edit; end

  def update
    if @document_client.update(params_document_client)
      success_update_message
      redirect_to staff_department_division_document_document_clients_path(@dept.id, @div.id, @doc.id)
    else
      error_message
      render :edit
    end
  end

  def show; end

  def destroy
    success_destroy_message if @document_client.destroy
    redirect_to staff_department_division_document_document_clients_path(@dept.id, @div.id, @doc.id)
  end

  def import
    if DocumentClient.import(params[:csv], params[:document_id])
      success_create_message
    else
      error_message
    end
    redirect_to staff_department_division_document_document_clients_path(@dept.id, @div.id, @doc.id)
  end

  private

  def params_document_client
    params.require(:document_client).permit(:document_id, :client_id, :cpf, information: {})
  end

  def set_document_client
    @document_client = DocumentClient.find(params[:id])
  end

  def set_department
    @dept = Department.find(params[:department_id])
  end

  def set_division
    @div = Division.find(params[:division_id])
  end

  def set_document
    @doc = Document.find(params[:document_id])
  end

  def request_signature?
    if @doc.request_signature
      redirect_to staff_department_division_documents_path(@dept, @div)
      flash[:alert] = 'Já foi solicitado assinatura'
    end
  end
end