class Admin::DivisionsController < Admin::BaseController
  before_action :set_division, only: [:show, :edit, :update, :destroy]
  # before_action :set_department_member, only: [:members, :add_member, :remove_member]
  before_action :set_division_member, only: [:members, :add_member, :remove_member]
  before_action :set_member, only: [:add_member]
  before_action :set_department

  def index
    @divisions = Division.where(department_id: params[:department_id])
                         .page(params[:page])
                         .search(params[:term])
  end

  def show
    @members = @division.users.order('division_users.role_id', :name)
  end

  def new
    department = Department.find(params[:department_id])
    @division = department.divisions.build
  end

  def create
    department = Department.find(params[:department_id])
    @division = department.divisions.create(division_params)
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
    @members = @div.users.order(:name)
    @no_members = Division.not_in_user(@dept, @div).order(:name)
    @roles = Role.where_roles(params[:division_id], true)
  end

  def add_member
    if @member.save
      success_add_member_message(:department_users)
    else
      error_add_member_message
    end
    redirect_to admin_department_division_members_path(params[:department_id], @div)
  end

  def remove_member
    member = @div.division_users.find_by(user_id: params[:user_id])
    success_remove_member_message(:division_users) if member.destroy

    redirect_to admin_department_division_members_path(params[:department_id], @div)
  end

  private

  def division_params
    params.require(:division).permit(:name, :description, :kind)
  end

  def set_division
    @division = Division.find(params[:id])
  end

  def set_department
    @dept = Department.find_by(id: params[:department_id])
  end

  def set_division_member
    @div = Division.find_by(id: params[:division_id])
  end

  def set_member
    div = Division.find_by(id: params[:division_id])
    @member = div.division_users.build(user_id: params[:member][:user],
                                       role_id: params[:member][:role])
  end
end
