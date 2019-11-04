class Staff::DocumentsController < Staff::BaseController
  before_action :set_document, only: [:edit, :update, :destroy]
  before_action :set_division
  before_action :load_users, only: [:new, :create, :edit, :update]
  before_action :permission

  def show
    @document = Document.includes(document_users: :user).find(params[:id])
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

  private

  def load_users
    @users = User.activated.order('name ASC')
  end

  def set_division
    @div = Division.find(params[:division_id])
  end

  def permission
    @divs = current_user.departments.find_by(department_users:
                                                    { role_id: Role.manager }).divisions
    @divs += Division.joins(:division_users)
                     .where(division_users: { user_id: current_user.id })

    if @divs.include?(@div)
    else
      flash[:alert] = 'Não possui permissão documento'
      redirect_to staff_root_path
    end
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :front, :back, :division_id,
                                     document_users_attributes: [:id, :user_id,
                                                                 :function,
                                                                 :destroy])
  end
end
