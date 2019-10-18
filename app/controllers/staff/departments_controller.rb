class Staff::DepartmentsController < Staff::BaseController
  include RemoveMember
  before_action :set_department, only: [:show, :edit, :update, :members, :remove_member]
  before_action :set_member_add, only: [:add_member]
  before_action :set_member, only: [:show, :members]
  before_action :department_permission, only: [:show, :edit, :update, :members, :remove_member]

  def index
    @departments = Department.manager(current_user.id)
  end

  def show; end

  def edit; end

  def update
    if @department.update(department_params)
      success_update_message
      redirect_to staff_departments_path
    else
      error_message
      render :edit
    end
  end

  def members
    @no_members = User.not_in(@department).order(name: :asc)
    @roles = Role.where_roles(params_keys, false)
  end

  def add_member
    if @member.save
      success_add_member_message(:department_users)
    else
      flash[:error] = @member.errors.full_messages.to_sentence
    end
    redirect_to staff_department_members_path(@member.department_id)
  end

  def remove_member
    remove(@department)
    redirect_to staff_department_members_path(@department)
  end

  private

  def department_permission
    id = params_keys
    dept = Department.manager(current_user.id)
    redirect_to staff_departments_path unless dept.ids.include?(id.to_i)
  end

  def set_department
    @department = Department.find(params_keys)
  end

  def set_member_add
    dept = Department.find(params_keys)
    @member = dept.department_users.build(user_id: params[:member][:user],
                                          role_id: params[:member][:role])
  end

  def set_member
    dept = Department.find(params_keys)
    @members = dept.users.order('department_users.role_id', :name)
  end

  def department_params
    params.require(:department).permit(:name, :initials, :phone, :description, :local, :email)
  end

  def params_keys
    params[:id] || params[:department_id]
  end
end
