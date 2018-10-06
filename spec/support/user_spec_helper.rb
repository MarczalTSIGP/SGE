module UserSpecHelper
  class << self
    def translate_active(user)
      if user.active?
         I18n.t('helpers.boolean.user.true')
      else
         I18n.t('helpers.boolean.user.false')
      end
    end

    def mask_cpf(cpf)
      cpf.insert(3, '.')
      cpf.insert(7, '.')
      cpf.insert(11, '-')
    end
  end

end