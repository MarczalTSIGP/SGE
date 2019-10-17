class Staff::Devise::RegistrationsController < Devise::RegistrationsController
  layout 'layouts/staff/application'

  protected

  def after_update_path_for(*)
    staff_edit_user_registration_path
  end

  def account_update_params
    params.require(:user).permit(:name, :alternative_email,
                                 :registration_number,
                                 :current_password)
  end
end
