class Staff::HomeController < Staff::BaseController
  before_action :signature

  def index; end

  private

  def signature
    @user_documents = User.signature(current_user)
    return unless @user_documents.empty?

    flash[:notice] = t('views.pages.sign.empty')
  end
end
