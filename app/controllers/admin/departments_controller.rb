class Admin::DepartmentsController < Admin::BaseController
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  def index
    # @users = User.order(:name).page params[:page]
    @departments = Department.page(params[:page]).search(params[:term])
  end

  def show; end

  def new
    @department = Department.new
  end

  def edit
    @department.remove_domain_email
  end

  def create
    @department = Department.new(department_params)

    if @department.save
      flash[:success] = I18n.t('flash.actions.create.f',
                               resource_name: Department.model_name.human)
      redirect_to admin_department_path(@department)
    else
      flash[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @department.update(department_params)
      flash[:success] = I18n.t('flash.actions.update.f',
                               resource_name: Department.model_name.human)
      redirect_to admin_department_path(@department)
    else
      @department.remove_domain_email
      render :edit
    end
  end

  def destroy
    @department.destroy
    flash[:success] = I18n.t('flash.actions.destroy.f', resource_name: Department.model_name.human)
    redirect_to admin_departments_path
  end

  def members
    @department = Department.find(params[:department_id])
    @members = @department.users.where(active: true).order(:name)
    @no_members = User.not_in(@department).order(name: :asc)
    @roles = Role.where_roles(params[:department_id])
  end

  def add_member
    @department = Department.find(params[:department_id])
    member = @department.department_users.build(user_id: params[:member][:user],
                                                role_id: params[:member][:role])
    if member.save
      flash[:success] = "Membro adicionado com sucesso"
    else
      flash[:error] = "Problemas na adição"
    end
    redirect_to admin_department_members_path(@department)
  end

  def remove_member
    @department = Department.find(params[:department_id])
    member = @department.department_users.find_by_user_id(params[:user_id])
    if member.destroy
      flash[:success] = "Membro removido com sucesso"
    else
      flash[:error] = "Problemas na remoção"
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
