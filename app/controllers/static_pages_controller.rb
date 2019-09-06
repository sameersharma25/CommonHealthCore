class StaticPagesController < ApplicationController

	def about
		@about_us = AboutU.all
		logger.debug("hmm #{@about_us}")
	end 

	def faq
		@faq = Faq.all 
	end 
end
