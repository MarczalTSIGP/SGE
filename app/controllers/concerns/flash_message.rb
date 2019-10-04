module FlashMessage
  extend ActiveSupport::Concern

  def success_create_message(gender: 'm')
    flash[:success] = I18n.t("flash.actions.create.#{gender}", resource_name: model_human)
  end

  def success_update_message(gender: 'm')
    flash[:success] = I18n.t("flash.actions.update.#{gender}", resource_name: model_human)
  end

  def success_destroy_message(gender: 'm')
    flash[:success] = I18n.t("flash.actions.destroy.#{gender}", resource_name: model_human)
  end

  def error_message
    flash.now[:error] = I18n.t('flash.actions.errors')
  end

  def success_add_member_message(model_name)
    add_remove(:success, :add, model_name)
  end

  def success_remove_member_message(model_name)
    add_remove(:success, :destroy, model_name)
  end

  private

  def add_remove(flash_type, action, model_name)
    resource_name = I18n.t("activerecord.models.#{model_name}.one")
    flash[flash_type] = I18n.t("flash.actions.#{action}.m", resource_name: resource_name)
  end

  def model_human
    model = controller_name.classify.constantize
    model.model_name.human
  end
end
