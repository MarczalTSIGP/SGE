class Admin::DepartmentsController < Admin::BaseController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  before_action :set_department_member, only: [:add_member, :remove_member]

  def index
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
      flash[:success] = I18n.t('flash.actions.create.m',
                               resource_name: Department.model_name.human)
      redirect_to admin_departments_path
    else
      flash[:error] = I18n.t('flash.actions.errors')
      @department.remove_domain_email
      render :new
    end
  end

  def update
    if @department.update(department_params)
      flash[:success] = I18n.t('flash.actions.update.m',
                               resource_name: Department.model_name.human)
      redirect_to admin_departments_path
    else
      flash[:error] = I18n.t('flash.actions.errors')
      @department.remove_domain_email
      render :edit
    end
  end

  def destroy
    @department.destroy
    flash[:success] = I18n.t('flash.actions.destroy.m', resource_name: Department.model_name.human)
    redirect_to admin_departments_path
  end

  def members
    @department = Department.find_by(id: params[:department_id])
    @members = @department.users.where(active: true).order(:name)
    @no_members = User.not_in(@department).order(name: :asc)
    @roles = Role.where_roles(params[:department_id])
  end

  def add_member
    member = set_member
    if member.save
      flash[:success] = I18n.t('flash.actions.add.m',
                               resource_name: t('views.names.member.singular'))
    else
      flash[:error] = I18n.t('flash.actions.errors')
    end
    redirect_to admin_department_members_path(@dept)
  end

  def remove_member
    member = @dept.department_users.find_by(user_id: params[:user_id])
    if member.destroy
      flash[:success] = I18n.t('flash.actions.destroy.m',
                               resource_name: t('views.names.member.singular'))
    else
      flash[:error] = I18n.t('flash.actions.errors')
    end
    redirect_to admin_department_members_path(@dept)
  end

  private

  def set_department
    @department = Department.find(params[:id])
  end

  def set_department_member
    @dept = Department.find_by(id: params[:department_id])
  end

  def set_member
    @dept.department_users.build(user_id: params[:member][:user],
                                 role_id: params[:member][:role])
  end

  def department_params
    params.require(:department).permit(:name, :initials, :phone, :description, :local, :email)
  end
end
