module Admin::Users::RegistrationsHelper
  def link_to_active_disable(user)
    if user.active?
      link_to admin_user_disable_path(user), method: :delete,
        class: 'icon',
        title: t('helpers.links.disable',
                 model: t('activerecord.models.user.one')),
        data: { toggle: 'tooltip', placement: 'top' } do
        raw("<i class='fe fe-user-x'></i>")
      end
    else
      link_to admin_user_active_path(user), method: :put,
        class: 'icon',
        title: t('helpers.links.active',
                 model: t('activerecord.models.user.one')),
        data: { toggle: 'tooltip', placement: 'top' } do
        raw("<i class='fe fe-user-check'></i>")
      end
    end
  end
end
