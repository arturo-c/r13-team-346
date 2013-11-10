class NotificationsController < ApplicationController
  def viewed_notification
    @notification = Notification.where({ :flag_read => nil })
    @notification.flag_read = true
    @notification.save
    respond do
  end
end