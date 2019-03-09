class Admin::DocumentsController < Admin::BaseController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :load_clients, only: [:new, :create, :edit, :update]
  before_action :load_users, only: [:new, :create, :edit, :update]

  def index
    @documents = Document.page(params[:page]).per(10).search(params[:term])
    return unless @documents.empty?

    flash.now[:notice] = t('flash.actions.search.empty.m',
                           model: t('activerecord.models.document.one'))
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      flash[:success] = t('flash.actions.create.m',
                          model: t('activerecord.models.document.one'))
      redirect_to admin_documents_path
    else
      flash.now[:error] = t('flash.actions.errors')
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @document.update(document_params)
      flash[:success] = t('flash.actions.update.m',
                          model: t('activerecord.models.document.one'))
      redirect_to admin_documents_path
    else
      flash.now[:error] = t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    if subscription?
      flash[:alert] = 'Não é possível remover documento com assinatura!'
    elsif @document.destroy
      flash[:success] = I18n.t('flash.actions.destroy.m',
                               model: t('activerecord.models.document.one'))
    end
    redirect_to admin_documents_path
  end

  def subscriptions
    @user_documents = UsersDocument.where(user_id: current_user, subscription: false)
  end

  def sign
    redirect_to admin_users_documents_subscriptions_path
  end

  private

  def load_clients
    @clients = Client.order(:name)
  end

  def load_users
    @users = User.where(support: false).where(active: true).order(:name)
  end

  def set_document
    @document = Document.find_by(id: params[:id])
  end

  def document_params
    params.require(:document).permit(:description,
                                     :kind, :activity,
                                     :participants,
                                     users_documents_attributes: [:id, :user_id,
                                                                  :function,
                                                                  :_destroy])
  end

  def subscription?
    @document.users_documents.each do |ud|
      return ud.subscription? == true
    end
  end
end
