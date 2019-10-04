module Helpers
  module I18nMessages
    # Flash messages
    #--------------------
    def flash_errors_msg
      I18n.t('flash.actions.errors')
    end

    def flash_not_authorized_msg
      I18n.t('flash.not_authorized')
    end

    def flash_msg(key)
      I18n.t("flash.actions.#{key}", resource_name: resource_name)
    end

    # Model messages
    #--------------------
    def required_error_msg_for(key)
      t = I18n.t(key)
      msg = I18n.t('errors.messages.required')
      "#{t} #{msg}"
    end

    # SimpleForm messages
    #--------------------
    def sf_blank_error_msg
      I18n.t('errors.messages.blank')
    end

    def sf_required_error_msg
      I18n.t('errors.messages.required')
    end

    def sf_invalid_error_msg
      I18n.t('errors.messages.invalid')
    end

    def sf_length_minimum(lenght)
      I18n.t('errors.messages.too_short', count: lenght)
    end

    def sf_length_maximum(lenght)
      I18n.t('errors.messages.too_long', count: lenght)
    end

    def sf_default_error_msg
      I18n.t('simple_form.error_notification.default_message')
    end

    def sf_confirmation_pwd_error_msg
      I18n.t('errors.messages.confirmation',
             attribute: I18n.t('activerecord.attributes.user.password'))
    end

    def sf_minimum_pwd_length
      I18n.t('errors.messages.too_short', count: 6)
    end

    def sf_image_error_msg
      I18n.t('errors.messages.extension_whitelist_error',
             extension: '"pdf"',
             allowed_types: 'jpg, jpeg, gif, png')
    end

    def sf_not_found_msg
      I18n.t('errors.messages.not_found')
    end

    # Devise messages
    #--------------------
    def devise_signed_in_msg
      I18n.t('devise.sessions.signed_in')
    end

    def devise_signed_out_msg
      I18n.t('devise.sessions.signed_out')
    end

    def devise_already_signed_out_msg
      I18n.t('devise.sessions.already_signed_out')
    end

    def devise_password_updated_msg
      I18n.t('devise.passwords.updated')
    end

    def devise_registrations_updated_msg
      I18n.t('devise.registrations.updated')
    end

    def devise_signed_up_msg
      I18n.t('devise.registrations.signed_up')
    end

    def devise_unauthenticated_msg
      I18n.t('devise.failure.unauthenticated')
    end

    def devise_invalid_sign_in_msg(authentication_keys = 'Login')
      I18n.t('devise.failure.invalid', authentication_keys: authentication_keys)
    end

    def devise_user_locked_msg
      I18n.t('devise.failure.locked')
    end

    # Devise kaminari
    #--------------------
    def pagination_total_entries(options)
      I18n.t('helpers.page_entries_info.one_page.display_entries.other',
             count: options[:count], entry_name: resource_name_plural)
    end

    def pagination_one_entry
      I18n.t('helpers.page_entries_info.one_page.display_entries.one',
             entry_name: resource_name)
    end

    def pagination_zero_entries
      I18n.t('helpers.page_entries_info.one_page.display_entries.zero',
             entry_name: resource_name_plural)
    end
  end
end
