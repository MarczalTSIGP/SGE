module Helpers
  module Page
    def click_on_link(url, options = {})
      link = "a[href='#{url}']"
      link += "[data-method='#{options[:method]}']" if options[:method]

      find(link).click
    end
  end
end
