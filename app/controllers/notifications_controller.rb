def index
    @notifications = Notification.where(recipient_id: current_user.id).all
end
