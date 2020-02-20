class StaticPagesController < ApplicationController

	def about
	    ca_id = current_user.client_application_id
			@about_us = AboutU.where(client_application_id: ca_id).entries
	end 

	def faq
	    ca_id = current_user.client_application_id
	    @faqs = Faq.where(client_application_id: ca_id).entries
	end 

	def admin_contact
		#find master application
		#master_app = ClientApplication.find_by(master_application_status: true)
		#find users with master application ID and Admin == true
		#@admin_user = User.where(:admin => true, :client_application_id => master_app.id).entries

		@admin_user = ClientApplication.where(master_application_status: true).first.users.first
	end 

	def redirect_page
		#google oAuth redirect page when email is not present 
	end 

	def no_url
	end 
end
