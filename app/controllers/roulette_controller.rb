class RouletteController < ApplicationController

  before_filter :signed_in_user, only: [:index]

end
