class ApplicationController < ActionController::Base
  protect_from_forgery

  # load all session helper methods! crucial!
  include SessionsHelper


	# VideoSoftware.pro Roulette Function by Vincent
	rescue_from 'REXML::ParseException' do |exception|
    render 'roulette/configfile.xml', :content_type => 'application/xml'
  end



end
