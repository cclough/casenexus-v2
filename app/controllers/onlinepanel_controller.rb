class OnlinepanelController < ApplicationController

  def index
    render partial: "index", layout: false
  end

  def show
    render partial: "show"
  end

end
