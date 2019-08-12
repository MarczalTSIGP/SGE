class Admin::DepartmentsController < Admin::BaseController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  before_action :set_department_member, only: [:members, :remove_member]
  before_action :set_member, only: [:add_member]

  def index
    @departments = Department.page(params[:page]).search(params[:term])
  end

  def show
    @members = @department.users.activated.order('department_users.role_id', :name)
  end

  def new
    @department = Department.new
  end

  def edit; end

  def create
    @department = Department.new(department_params)
    if @department.save
      success_create_message
      redirect_to admin_departments_path
    else
      error_message
      render :new
    end
  end

  def update
    if @department.update(department_params)
      success_update_message
      redirect_to admin_departments_path
    else
      error_message
      render :edit
    end
  end

  def destroy
    @department.destroy
    success_destroy_message
    redirect_to admin_departments_path
  end

  def members
    @members = @dept.users.order('department_users.role_id', :name)
    @no_members = User.not_in(@dept).order(name: :asc)
    @roles = Role.where_roles(params[:department_id])
  end

  def add_member
    if @member.save
      success_add_member_message(:department_users)
    else
      error_add_member_message
    end

    redirect_to admin_department_members_path(@member.department_id)
  end

  def remove_member
    member = @dept.department_users.find_by(user_id: params[:user_id])
    success_remove_member_message(:department_users) if member.destroy

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
    dept = Department.find_by(id: params[:department_id])
    @member = dept.department_users.build(user_id: params[:member][:user],
                                          role_id: params[:member][:role])
  end

  def department_params
    params.require(:department).permit(:name, :initials, :phone, :description, :local, :email)
  end
end
