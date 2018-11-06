class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if valid?(value)

    record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid'))
  end

  def valid?(cpf)
    digits = cpf.to_s.split(//).map(&:to_i)
    digit_nine = digits[9]
    digit_ten = digits[10]
    first_nine_digits = digits.take(9)
    first_ten_digits = digits.take(10)

    digit_nine == calc_cpf_digit(first_nine_digits) &&
      digit_ten == calc_cpf_digit(first_ten_digits)
  end

  def calc_cpf_digit(digits)
    soma = 0
    multi = 0
    digits.each_with_index do |digit, index|
      multi = digit * (digits.length + 1 - index)
      soma += multi
    end
    result = soma * 10 % 11

    return 0 if result == 10

    result
  end
end
