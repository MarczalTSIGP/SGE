class Admin::DepartmentController < Admin::BaseController
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  def index
    @departments = Department.all
  end

  def show
  end

  def new
    @department = Department.new
  end

  def edit
  end

  def create
    @department = Department.new(department_params)

    if @department.save
      flash[:success] = 'Departamento criado com sucesso.'
      redirect_to admin_department_path(@department)
    else
      flash[:error] = 'Existem dados incorretos! Por favor verifique.'
      render :new
    end
  end

  def update
    if @department.update(department_params)
      flash[:success] = 'Departamento alterado com sucesso.'
      redirect_to admin_department_path(@department)
    else
      render :edit
    end
  end

  def destroy
    @department.destroy
    flash[:success] = 'Departamento deletado com sucesso.'
    redirect_to admin_department_index_path
  end

  private
  def set_department
    @department = Department.find(params[:id])
  end

  def department_params
    params.require(:department).permit(:name,:initials,:phone,:description,:local,:department_email,:department_responsible)
  end
end
