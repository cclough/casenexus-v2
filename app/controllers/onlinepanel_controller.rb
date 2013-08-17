class OnlinepanelController < ApplicationController

  def container
    render partial: "container", layout: false
  end

  def index
    render partial: "index", layout: false
  end

  def show
    render partial: "show"
  end

end
