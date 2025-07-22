class Admin::BaseController < ApplicationController
  before_action :require_login
  before_action :require_admin
  
  layout 'admin'
  
  protected
  
  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end