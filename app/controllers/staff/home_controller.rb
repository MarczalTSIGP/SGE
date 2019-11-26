class Staff::HomeController < Staff::BaseController
  before_action :signature

  def index; end

  private

  def signature
    @user_documents = User.signature(current_user).includes(document: [:document_clients])
    return unless @user_documents.empty?

    flash[:alert] = t('views.pages.sign.empty')
  end
end
