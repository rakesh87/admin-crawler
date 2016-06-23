class DashboardController < ApplicationController

	before_action :authenticate_user!


	def index
		@activities = current_user.activities
	end

	def help; end

end