class Admin::UsersController < Admin::BaseController

  before_action :set_user, only: [:active, :disable, :edit, :update, :show]

  def index
    @users = User.page(params[:page]).per(10).search(params[:term])
    if @users.empty?
      flash.now[:notice] =t('flash.actions.search.empty.m',
                            model: t('activerecord.models.user.one'))
    end
  end

  def show;  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      flash[:success] = t('flash.actions.create.m',
                          model: t('activerecord.models.user.one'))
      redirect_to admin_users_path
    else
      flash.now[:error] = t('flash.actions.errors')
      render :new
    end
  end

  def edit;  end

  def update
    if @user.update(users_params)
      flash[:success] = t('flash.actions.update.m',
                          model: t('activerecord.models.user.one'))
      redirect_to admin_users_path
    else
      flash.now[:error] = t('flash.actions.errors')
      render :edit
    end
  end

  def disable
    @user.update(active: false)
    flash[:success] = t('flash.actions.disable.m',
                        model: t('activerecord.models.user.one'))
    redirect_to admin_users_path
  end

  def active
    @user.update(active: true)
    flash[:success] = t('flash.actions.active.m',
                        model: t('activerecord.models.user.one'))
    redirect_to admin_users_path
  end

  private

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
