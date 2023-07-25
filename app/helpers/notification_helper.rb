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
      sender_id: current_user.id,
      recipient_id: user.id,
      body: "#{current_user.username} rejected your connection request"
    )

    ActionCable.server.broadcast("notification_#{user.id}", {
                                   sender_id: current_user.id,
                                   message: "#{current_user.username} rejected your connection request",
                                   recipient_id: user.id
                                 })
  end

  def send_accept_request_notification(user_id)
    user = User.find(user_id)

    notification = Notification.create(
      sender_id: current_user.id,
      recipient_id: user.id,
      body: "#{current_user.username} accepted your connection request"
    )

    ActionCable.server.broadcast("notification_#{user.id}", {
                                   sender_id: current_user.id,
                                   message: "#{current_user.username} accepted your connection request",
                                   recipient_id: user.id
                                 })
  end

  def send_job_post_creation_notification
    user = User.find_by(role: 'admin')

    notification = Notification.create(
      sender_id: current_user.id,
      recipient_id: user.id,
      body: "Please review #{current_user.username} new job post"
    )

    ActionCable.server.broadcast("notification_#{user.id}", {
                                   sender_id: current_user.id,
                                   message: "Please review #{current_user.username} new job post",
                                   recipient_id: user.id
                                 })
  end

  def send_job_post_approve_notification(user_id)
    notification = Notification.create(
      sender_id: current_user.id,
      recipient_id: user_id,
      body: 'Your job post is approved'
    )

    ActionCable.server.broadcast("notification_#{user_id}", {
                                   sender_id: current_user.id,
                                   message: 'Your job post is approved',
                                   recipient_id: user_id
                                 })
  end

  def send_new_chat_notification(user)
    notification = Notification.create(
      sender_id: user.id,
      recipient_id: current_user.id,
      body: "#{user.username} started a conversation"
    )

    ActionCable.server.broadcast("notification_#{current_user.id}", {
                                   sender_id: user.id,
                                   message: "#{user.username} started a conversation",
                                   recipient_id: current_user.id
                                 })
  end

  def send_new_post_notification(skills_required, job_provider_id)
    all_users_except_admins = User.where.not(role: 'admin').where.not(id: job_provider_id)

    requirement_skills = skills_required.split(',').map(&:strip)

    users_with_matching_skills = all_users_except_admins.select do |user|
      user_skills = user.skills.split(',').map(&:strip)
      (user_skills & requirement_skills).any?
    end

    users_with_matching_skills.each do |user|
      notification = Notification.create(
        sender_id: current_user.id,
        recipient_id: user.id,
        body: 'There is a job requirement post that matches your skills.'
      )

      ActionCable.server.broadcast("notification_#{user.id}", {
                                     sender_id: current_user.id,
                                     message: 'There is a job requirement post that matches your skills.',
                                     recipient_id: user.id
                                   })
    end
  end
end
