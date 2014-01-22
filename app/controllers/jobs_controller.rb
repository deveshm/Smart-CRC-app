class JobsController < ApplicationController

	def check_email
        MailSynch.check_email
		redirect_to installations_path
	end  

end