class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless is_valid?(value)
      record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid'))
    end
  end

  def is_valid?(cpf)
    digits = cpf.to_s.split(//).map { |s| s.to_i }
    digit_9 = digits[9]
    digit_10 = digits[10]
    first_9_digits = digits.take(9)
    first_10_digits = digits.take(10)

    return digit_9 == calc_cpf_digit(first_9_digits) &&
           digit_10 == calc_cpf_digit(first_10_digits)
  end

  def calc_cpf_digit(digits)
    soma = 0
    multi = 0
    digits.each_with_index do |digit, index|
      multi = digit * (digits.length + 1 - index)
      soma += multi
    end
    result = soma * 10 % 11
    if result == 10
      return 0
    else
      return result
    end
  end
end
