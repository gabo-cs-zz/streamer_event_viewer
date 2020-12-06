# Navigation Helper
module NavigationHelper
  def navigation_partial_path
    if user_signed_in?
      'layouts/navigation/user_signed_in_links'
    else
      'layouts/navigation/non_signed_in_links'
    end
  end
end
