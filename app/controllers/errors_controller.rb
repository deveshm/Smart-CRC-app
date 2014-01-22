class ErrorsController < ApplicationController

  def installation_missing
  	@invalid_designation = params[:invalid_designation]
  end

end
