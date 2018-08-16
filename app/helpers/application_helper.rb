module ApplicationHelper
  def full_title(page_title = '', base_title = 'SGE')
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def bootstrap_class_for(flash_type)
    { success: 'notice-success', error: 'notice-danger', alert: 'notice-warning',
      notice: 'notice-info' }[flash_type.to_sym] || flash_type.to_s
  end

end
