class UsersController < ApplicationController

  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]

	def new
	end

	def index
	end

	def edit
	end

  def update
  end

end
