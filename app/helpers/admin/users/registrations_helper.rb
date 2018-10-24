module Admin::Users::RegistrationsHelper
  def link_to_active_disable(user)
    if user.active?
      link(admin_user_disable_path(user), 'disable', 'user-x')
    else
      link(admin_user_active_path(user), 'active', 'user-check')
    end
  end

  private

  def link(path, status, icon)
    link_to path,
            method: :put, class: 'icon',
            title: t("helpers.links.#{status}",
                     model: t('activerecord.models.user.one')),
            data: { toggle: 'tooltip', placement: 'top' } do
      raw("<i class='fe fe-#{icon}'></i>")
    end
  end
end
