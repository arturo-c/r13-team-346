class NotificationsCell < Cell::Rails

  def show(args)
    @user = args[:user]
    if @user.present?
      @notifications = Notification.where({ 'game_admin_id' => @user.twitter_id }).order_by([:notifier_date_time, :desc])
      @unread_notifications = Notification.where({ 'flag_read' => 0 })
    end
    render
  end

end
