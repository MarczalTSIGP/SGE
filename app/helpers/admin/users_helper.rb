module Admin::UsersHelper
  def link_to_active_disable(user)
    if user.active?
      link(admin_user_disable_path(user), 'disable', 'user-lock')
    else
      link(admin_user_active_path(user), 'active', 'user-check')
    end
  end

  private

  def link(path, status, icon)
    link_to path, method: :put,
                  title: t("views.links.#{status}"),
                  data: { toggle: 'tooltip' } do

      content_tag(:i, '', class: "fas fa-#{icon} icon")
    end
  end
end
