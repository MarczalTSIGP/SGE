class Staff::DocumentsController < Staff::BaseController
  before_action :set_document, only: [:edit, :update, :destroy, :request_signature, :sign]
  before_action :set_division, except: [:sign, :auth]
  before_action :load_users, only: [:new, :create, :edit, :update]
  before_action :permission, except: [:sign, :auth]
  before_action :request_signature?, except: [:sign, :auth, :show, :index, :new, :create]

  def show
    @document = Document.includes(document_users: :user).find(params[:id])
    respond_to do |format|
      format.html
      format.csv {
        send_data Document.to_csv(params[:id]), filename: "document-#{@document.title}.csv"
      }
    end
  end

  def index
    @documents = Document.includes(:division)
                         .where(division_id: params[:division_id])
                         .page(params[:page])
                         .search(params[:term])
  end

  def new
    @document = @div.documents.build
  end

  def create
    @document = @div.documents.create(document_params)
    if @document.save
      success_create_message
      redirect_to staff_department_division_documents_path(@document.division.department,
                                                           @document.division)
    else
      error_message
      render :new
    end
  end

  def edit; end

  def update
    if @document.update(document_params)
      success_update_message
      redirect_to staff_department_division_documents_path(@document.division.department,
                                                           @document.division)
    else
      error_message
      render :edit
    end
  end

  def destroy
    success_destroy_message if @document.destroy
    redirect_to staff_department_division_documents_path(@document.division.department,
                                                         @document.division)
  end

  def request_signature
    if !@document.request_signature?
      flash[:success] = 'Sucesso solicitação de assinatura'
      @document.request_signature = true
      @document.save
    else
      # flash[:alert] = I18n.t('flash.actions.request_signature.signature')
      flash[:alert] = 'Já possui assinatura'
    end
    redirect_to staff_department_division_documents_path(@document.division.department,
                                                         @document.division)
  end

  def auth
    @user = User.auth(params[:document][:login], params[:document][:password])
    if current_user == @user
      @user_documents = DocumentUser.find_by(document_id: params[:id], user_id: @user)
      @user_documents.signature_datetime = Time.zone.now
      DocumentUser.toggle_subscription(@user_documents)
      flash[:success] = t('views.pages.sign.sucess')
      redirect_to staff_root_path
    else
      flash[:alert] = I18n.t('views.pages.sign.erro')
      render :sign
    end
  end

  def sign; end

  private

  def load_users
    @users = User.activated.order('name ASC')
  end

  def set_division
    @div = Division.find(params[:division_id])
  end

  def permission
    @divs = Division.joins(:division_users)
              .where(division_users: { user_id: current_user.id })
    divs = current_user.departments.find_by(department_users:
                                                    { role_id: Role.manager })
      @divs += divs.divisions if divs.present?
    if @divs.include?(@div)
    else
      flash[:alert] = 'Não possui permissão documento'
      redirect_to staff_divisions_path
    end
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :front, :back, :division_id, :variables,
                                     document_users_attributes: [:id, :user_id,
                                                                 :function,
                                                                 :_destroy])
  end

  def request_signature?
    if @document.request_signature
      redirect_to staff_department_division_documents_path(@div.department,
                                                           @div)
      flash[:alert] = 'Já foi solicitado assinatura'
    end
  end
end
