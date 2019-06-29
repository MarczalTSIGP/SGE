module Helpers
  module FlashMessage
    def errors_message
      I18n.t('flash.actions.errors')
    end

    def blank_error_message
      I18n.t('errors.messages.blank')
    end

    def required_error_message
      I18n.t('errors.messages.required')
    end

    def invalid_error_message
      I18n.t('errors.messages.invalid')
    end

    def default_error_message
      I18n.t('simple_form.error_notification.default_message')
    end

    def confirm_password_error_message
      I18n.t('errors.messages.confirmation',
             attribute: I18n.t('activerecord.attributes.user.password'))
    end

    def minimum_password_length
      I18n.t('errors.messages.too_short', count: 6)
    end

    def profile_image_error_message
      I18n.t('errors.messages.extension_whitelist_error', extension: '"pdf"',
                                                          allowed_types: 'jpg, jpeg, gif, png')
    end

    def signed_in_message
      I18n.t('devise.sessions.signed_in')
    end

    def already_signed_out_message
      I18n.t('devise.sessions.already_signed_out')
    end

    def invalid_sign_in_message(authentication_keys = 'Login')
      I18n.t('devise.failure.invalid', authentication_keys: authentication_keys)
    end

    def registrations_updated_message
      I18n.t('devise.registrations.updated')
    end

    def signed_up_message
      I18n.t('devise.registrations.signed_up')
    end

    def unauthenticated_message
      I18n.t('devise.failure.unauthenticated')
    end

    def not_authorized_message
      I18n.t('flash.not_authorized')
    end

    def user_locked_message
      I18n.t('devise.failure.locked')
    end
  end
end
