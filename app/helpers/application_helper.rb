module ApplicationHelper
  def full_title(page_name = "")
    basic_title = "AttendanceApp"
    if page_name.empty?
      basic_title
    else
      page_name + '|' + basic_title
    end
  end
end
