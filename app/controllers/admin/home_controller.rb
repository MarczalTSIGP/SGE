class Admin::HomeController < Admin::BaseController

  def index
    @department_number = Department.count
  end

end
