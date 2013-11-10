class NotificationsController < ApplicationController
  def viewed_notification
    @notification = Notification.where({ :flag_read => nil })
    @notification.flag_read = true
    @notification.save
    respond_to do |format|
      format.html
      format.json { render :json => @notifications.to_json }
      format.js
    end
  end
end