module HomeHelper
  def home_content_partial_path
    if user_signed_in?
      'home/user_signed_in_content'
    else
      'home/non_signed_in_content'
    end
  end
end
