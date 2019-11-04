module Helpers
  module Form
    def submit_form(submit = 'input[name="commit"]')
      find(submit).click
    end

    def fill_and_submit_form(form, fields)
      within(form) do
        fields.each do |field, val|
          fill_in field, with: val
        end

        yield if block_given?
      end
      submit_form
    end

    def attributes_for_form(model)
      attributes = attributes_for(model)
      attributes.keys.each { |k| attributes["#{model}_#{k}".to_sym] = attributes.delete(k) }
      attributes
    end

    def choose_radio_button(value, options = {})
      find("div.#{options[:from]} label.custom-radio", text: value).click
    end

    def selectize(name, id)
      find(:css, id).set(name)
      find('div.selectize-dropdown-content .option', text: name).click
    end
  end
end
