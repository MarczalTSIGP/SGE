class Admin::DepartmentsController < Admin::BaseController
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  def index
    @departments = Department.page(params[:page]).per(12)
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
    redirect_to admin_departments_path
  end

  def members
    @department = Department.find(params[:department_id])
    @members = @department.users
    @no_members = User.not_in(@department)
    @roles = Role.all
  end

  def add_member
    @department = Department.find(params[:department_id])
    member = @department.department_users.build(user_id: params[:member][:user],
                                              role_id: params[:member][:role])
    p member
    if member.save
      flash[:sucess] = "Membro adicionado com sucesso"
    else
      flash[:danger] = "Problemas na adição"
    end
    redirect_to admin_department_members_path(@department)
  end

  private
  def set_department
    @department = Department.find(params[:id])
  end

  def department_params
    params.require(:department).permit(:name, :initials, :phone, :description, :local, :email)
  end
end
