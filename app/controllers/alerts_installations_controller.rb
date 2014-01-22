  class AlertsInstallationsController < ApplicationController

before_filter :find_installation

  def index
      @alerts = @alerts.page(params[:page]).per(10)
      render "installations/alerts/index"
  end

  def edit
    @alert  = Alert.find(params[:id])
    render 'installations/alerts/edit' 
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
      redirect_to installation_alerts_path(@alert.installation)

  end

  def handle_failed_edit
      render 'installations/alerts/edit'
  end

  private 
  def find_installation
       @installation = Installation.find_by_designation(params[:installation_id]) if params[:installation_id]
       @alerts = @installation ? @installation.alerts : Alert.order('created_at DESC')
  end
end