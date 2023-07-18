module NotificationHelper
    def send_connect_notification(user)

        notification = Notification.create(
        sender_id: current_user.id,
        recipient_id: user.id,
        body: "#{current_user.username} wants to connect with you"
        )
        
        ActionCable.server.broadcast("notification_#{user.id}", {
        sender_id: current_user.id,
        message: "#{current_user.username} wants to connect with you",
        recipient_id: user.id
        })
    end

    def send_disconnect_notification(user)

        notification = Notification.create(
        sender_id: current_user.id,
        recipient_id: user.id,
        body: "#{current_user.username} disconnected from you"
        )
        
        ActionCable.server.broadcast("notification_#{user.id}", {
        sender_id: current_user.id,
        message: "#{current_user.username} disconnected from you",
        recipient_id: user.id
        })
    end

    def send_reject_request_notification(user_id)
        user = User.find(user_id)
        
        notification = Notification.create(
          sender_id: user.id,
          recipient_id: current_user.id,
          body: "#{current_user.username} rejected your connection request"
        )
        
        ActionCable.server.broadcast("notification_#{user.id}", {
          sender_id: user.id,
          message: "#{current_user.username} rejected your connection request",
          recipient_id: current_user.id
        })
    end

    def send_accept_request_notification(user_id)
        user = User.find(user_id)
        
        notification = Notification.create(
          sender_id: user.id,
          recipient_id: current_user.id,
          body: "#{current_user.username} accepted your connection request"
        )
        
        ActionCable.server.broadcast("notification_#{user.id}", {
          sender_id: user.id,
          message: "#{current_user.username} accepted your connection request",
          recipient_id: current_user.id
        })
    end
      

end