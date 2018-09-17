class Admin::Users::DisabledController < Admin::BaseController
  before_action :set_disabled, only: [:destroy, :update]
  before_action :admin?
  def index

    @users = User.all
    if params[:search]
      @users = User.search(params[:search]).where(support: false).order('created_at DESC')
    else
      @users = User.all.where(support: false).order('created_at DESC')
    end
    render 'admin/users/registrations/index'
  end


  def destroy
    @user.active = false
    @user.save
    flash[:notice] = "Desativado com sucesso!"
    redirect_to admin_users_disabled_path
  end

  def update
    @user.active = true
    @user.save
    flash[:notice] =  "Ativado com sucesso!"
    redirect_to admin_users_disabled_path
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_disabled
    @user = User.find(params[:id])
  end

  def disabled_params
    params.require(:disable).permit(:search, :id)
  end

  def admin?
    unless current_user.admin?
      redirect_to admin_root_path
    end
  end
end