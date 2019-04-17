class Admin::DocumentsController < Admin::BaseController
  before_action :set_document, only: [:show, :edit, :update, :destroy, :request_signature, :sign, :auth]
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

  def edit
    if @document.request_signature?
      flash[:alert] = t('flash.actions.request_signature.update')
      redirect_to admin_documents_path
    end
  end

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
    if @document.request_signature?
      flash[:alert] = t('flash.actions.request_signature.destroy')
    elsif @document.destroy
      flash[:success] = t('flash.actions.destroy.m',
                          model: t('activerecord.models.document.one'))
    end
    redirect_to admin_documents_path
  end

  def subscriptions
    @user_documents = UsersDocument.joins(:document).where(user_id: current_user,
                                                           subscription: false,
                                                           documents:
                                                               { request_signature: true })
    if @user_documents.empty?
      flash[:success] = I18n.t('flash.actions.sign.empty.m',
                               model: t('activerecord.models.document.one'))
    end
  end

  def auth
    if current_user == User.auth(params[:document][:login], params[:document][:password])
      @user = UsersDocument.find_by(document_id: params[:id], user_id: current_user)
      @user.subscription = true
      @user.save
      flash[:success] = I18n.t('flash.actions.sign.valid.m', model: t('activerecord.models.document.one'))
      redirect_to admin_users_documents_subscriptions_path
    else
      flash[:alert] = I18n.t('flash.actions.sign.invalid.m',
                             model: t('activerecord.models.document.one'))
      render :sign
    end
  end

  def sign; end

  def request_signature
    @document.users_documents.each do |ud|
      if ud.user_id == current_user.id
        if @document.request_signature?
          flash[:alert] = I18n.t('flash.actions.request_signature.f')
        else
          @document.request_signature = true
          @document.save
          flash[:success] = I18n.t('flash.actions.request_signature.t')
        end
      else
        flash[:alert] = I18n.t('flash.actions.request_signature.signature')
      end
      redirect_to admin_documents_path
    end
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
    params.require(:document).permit(:login, :description,
                                     :kind, :activity,
                                     :participants,
                                     :title,
                                     users_documents_attributes: [:id, :user_id,
                                                                  :function,
                                                                  :_destroy])
  end
end
