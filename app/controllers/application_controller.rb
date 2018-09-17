class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if resource_name == :user
      admin_root_path
    else
      super
    end
  end

  def after_update_path_for(resource)
    if resource_name == :user
      admin_root_path
    else
      super
    end
  end
end
