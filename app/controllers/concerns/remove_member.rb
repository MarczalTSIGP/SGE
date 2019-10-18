module RemoveMember
  extend ActiveSupport::Concern

  def remove(department)
    member = department.department_users.find_by(user_id: params[:user_id])
    if member.destroy_custom(member.user_id, department.divisions)
      success_remove_member_message(:department_users) if member.destroy
    else
      flash[:error] = I18n.t('flash.actions.destroy.bound',
                             resource_name: I18n.t('activerecord.models.department_users.one'))
    end
  end
end
