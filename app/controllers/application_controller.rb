class ApplicationController < ActionController::Base
  protect_from_forgery

  # load all session helper methods! crucial!
  include SessionsHelper

end
