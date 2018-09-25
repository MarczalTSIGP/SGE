class Admin::DepartmentUsersController < Admin::BaseController

  before_action :load_department, only: [:index, :add_manager, :add_coordinator_event, :destroy]
  before_action :set_department_role, only: [:destroy]

  def index
    @users = DepartmentRole.users(@department).order(:role_id)
    @user_role = DepartmentRole.new
  end

  def add_manager
    @department_role = DepartmentRole.new( department_roles_params)
    @department_role.department_id = @department.id
    @department_role.role_id = Role.manager.id
    if @department_role.save
      flash[:success] = 'Chefe adicionado com sucesso.'
      redirect_to admin_department_members_path
    else
      flash[:error] = 'Erro ao adicionar Chefe.'
      render :index
    end
  end

  def add_coordinator_event
    @department_role = DepartmentRole.new( department_roles_params)
    @department_role.department_id = @department.id
    @department_role.role_id = Role.coordinator.id
    if @department_role.save
      flash[:success] = 'Coordenador adicionado com sucesso.'
      redirect_to admin_department_members_path
    else
      flash[:error] = 'Erro ao adicionar Coordenador.'
      render :index
    end
  end

  def destroy
    @department_role.destroy
    flash[:success] = 'Usuário removido com sucesso.'
    redirect_to admin_department_members_path
  end

  private

  def set_department_role
    @department_role = DepartmentRole.find(params[:id])
  end

  def load_department
    @department = Department.find(params[:department_id])
  end

  def department_roles_params
    params.require(:department_role).permit(:user_id, :department_id)
  end

end
