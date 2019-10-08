class Admin::DivisionsController < Admin::BaseController
  before_action :set_department
  before_action :set_division, except: [:index, :new, :create]
  before_action :set_member, only: [:add_member]

  def index
    @divisions = @dept.divisions.page(params[:page])
                      .search(params[:term])
  end

  def show
    @members = @division.users.order('division_users.role_id', :name)
  end

  def new
    @division = @dept.divisions.build
  end

  def create
    @division = @dept.divisions.create(division_params)

    if @division.save
      success_create_message
      redirect_to admin_department_divisions_path
    else
      error_message
      render :new
    end
  end

  def edit; end

  def update
    if @division.update(division_params)
      success_update_message
      redirect_to admin_department_divisions_path
    else
      error_message
      render :edit
    end
  end

  def destroy
    @division.destroy
    success_destroy_message
    redirect_to admin_department_divisions_path(params[:department_id])
  end

  def members
    @members = @division.users.order(:name)
    @no_members = Division.not_in_user(@dept, @division).order(:name)
    @roles = Role.where_roles(params[:division_id], true)
  end

  def add_member
    if @member.save
      success_add_member_message(:department_users)
    else
      flash[:error] = @member.errors.full_messages.to_sentence
    end
    redirect_to admin_department_division_members_path(params[:department_id], @division)
  end

  def remove_member
    member = @division.division_users.find_by(user_id: params[:user_id])
    success_remove_member_message(:division_users) if member.destroy

    redirect_to admin_department_division_members_path(params[:department_id], @division)
  end

  private

  def division_params
    params.require(:division).permit(:name, :description)
  end

  def set_division
    id = params[:division_id] || params[:id]
    @division = @dept.divisions.find(id)
  end

  def set_department
    @dept = Department.find_by(id: params[:department_id])
  end

  def set_member
    @member = @division.division_users.build(user_id: params[:member][:user],
                                             role_id: params[:member][:role])
  end
end
