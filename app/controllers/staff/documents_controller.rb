class Staff::DocumentsController < Staff::BaseController
  before_action :set_document, only: [:edit, :update, :destroy, :show]
  before_action :set_divisions
  before_action :permission

  def show; end

  def index
    @documents = Document.where(division_id: @divisions)
                         .includes(:division)
                         .page(params[:page])
                         .search(params[:term])
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.create(document_params)
    if @document.save
      success_create_message
      redirect_to staff_documents_path
    else
      error_message
      render :new
    end
  end

  def edit; end

  def update
    if @document.update(document_params)
      success_update_message
      redirect_to staff_documents_path
    else
      error_message
      render :edit
    end
  end

  def destroy
    success_destroy_message if @document.destroy
    redirect_to staff_documents_path
  end

  private

  def set_divisions
    @divisions = Division.responsible(current_user)
    dept = Department.manager(current_user)
    @divisions = Department.divisions(dept, @divisions) if dept.present?
  end

  def permission
    ids = @divisions.map(&:id)
    if params[:id].nil? || ids.include?(@document.division_id)
    else
      flash[:alert] = 'Não possui permissão'
      redirect_to staff_documents_path
    end
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :front, :back, :division_id)
  end
end
