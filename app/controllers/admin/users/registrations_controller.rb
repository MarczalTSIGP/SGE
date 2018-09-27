class Admin::Users::RegistrationsController < Admin::BaseController



  before_action :set_user, only: [:active, :disable, :edit, :update]
  before_action :admin?, except: [:edit, :update]
  before_action :user?, only: [:edit, :update]

  def index

    @users = User.all
    if params[:search]
      @users = User.search(params[:search]).where(support: false).order('created_at DESC')
    else
      @users = User.all.where(support: false).order('created_at DESC')
    end

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    if @user.save
      flash[:sucess] = I18n.t('flash.messages.create', model: 'activerecord.model.user.one')
      redirect_to new_admin_user_registration_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @user.update(registration_params)
      flash[:notice] = 'Usuário editado com sucesso!'
      redirect_to admin_user_registration_index_path
    else
      render :edit
    end
  end

  def disable
    @user.active = false
    @user.save
    flash[:notice] = "Desativado com sucesso!"
    redirect_to admin_user_registration_index_path
  end

  def active
    @user.active = true
    @user.save
    flash[:notice] = "Ativado com sucesso!"
    redirect_to admin_user_registration_index_path
  end

  def destroy

  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def registration_params
    params.require(:user).permit(:name, :username, :alternative_email, :registration_number, :cpf, :active)
  end


  def admin?
    unless current_user.admin?
      redirect_to admin_root_path
    end
  end

  def user?
    unless current_user.eql? @user or current_user.admin?
      redirect_to admin_root_path
    end

  end
end