class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:active, :disable, :edit, :update, :show]

  def index
    @users = User.page(params[:page]).search(params[:term])
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      success_create_message
      redirect_to admin_users_path
    else
      error_message
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(users_params)
      success_update_message
      redirect_to admin_users_path
    else
      error_message
      render :edit
    end
  end

  def disable
    @user.update(active: false)
    flash_message(:disable)

    redirect_to admin_users_path
  end

  def active
    @user.update(active: true)
    flash_message(:active)

    redirect_to admin_users_path
  end

  private

  def flash_message(to)
    flash[:success] = t("flash.actions.#{to}.m", resource_name: t('activerecord.models.user.one'))
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def users_params
    params.require(:user).permit(:name,
                                 :username,
                                 :alternative_email,
                                 :registration_number, :cpf, :active, :admin)
  end
end
