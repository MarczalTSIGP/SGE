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
      flash[:success] = flash_message('create.m')

      redirect_to admin_users_path
    else
      flash.now[:error] = flash_message('errors')
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(users_params)
      flash[:success] = flash_message('update.m')

      redirect_to admin_users_path
    else
      flash.now[:error] = flash_message('errors')
      render :edit
    end
  end

  def disable
    @user.update(active: false)
    flash[:success] = flash_message('disable.m')

    redirect_to admin_users_path
  end

  def active
    @user.update(active: true)
    flash[:success] = flash_message('active.m')

    redirect_to admin_users_path
  end

  private

  def flash_message(to)
    t("flash.actions.#{to}", resource_name: t('activerecord.models.user.one'))
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def users_params
    params.require(:user).permit(:name,
                                 :username,
                                 :alternative_email,
                                 :registration_number, :cpf, :active)
  end
end
