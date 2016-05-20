class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(user)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(user) || request.referer || root_path
    end
  end

  def after_sign_out_path_for(user)
    stored_location_for(user) || request.referer || root_path
  end

  include Comfy::CmsHelper
  # used in CMS "step" pages to set up "next page" links
  def next_step_page(component)
    page = Comfy::Cms::Page.find_by(full_path: request.path)
    # TODO: Refactor from Ruby logic into query for speed
    next_page = Comfy::Cms::Page.where(position: page.position+1).select{ |p| p.categories.any?{|c| c.label == "Step" } }.first
    case component
    when "title"
      if next_page
        return "Step #{next_page.position}: #{next_page.label}"
      else
        return "Return to Homepage"
      end
    when "path"
      if next_page
        return next_page.full_path
      else
        return "/"
      end
    end
  end
  helper_method :next_step_page

  def page_slug
    Comfy::Cms::Page.find_by(full_path: request.path).slug
  end
  helper_method :page_slug

end
