class AlertsController < ApplicationController


  def index
    @alerts = Alert.order('created_at DESC').page(params[:page]).per(10)
  end

  def edit
    @alert  = Alert.find(params[:id])
  end

  def update
    @alert = Alert.find(params[:id])
    if @alert.update_attributes(params[:alert])
      handle_success_edit
    else
      handle_failed_edit
    end
  end

  def handle_success_edit
    flash[:success] = "Your Comment has been added/updated"
    redirect_to alerts_path
  end

  def handle_failed_edit
      render 'edit'
  end

  
end
