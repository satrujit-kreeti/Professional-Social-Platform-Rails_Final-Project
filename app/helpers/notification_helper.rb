# frozen_string_literal: true

module NotificationHelper
  def send_notification(senders_id, recipients_id, bodys)
    Notification.create(sender_id: senders_id, recipient_id: recipients_id, body: bodys)
    ActionCable.server.broadcast("notification_#{recipient_id}", {
                                   sender_id: senders_id,
                                   message: bodys,
                                   recipient_id: recipients_id
                                 })
  end

  def send_connect_notification(user)
    send_notification(current_user.id, user.id, "#{current_user.username} wants to connect with you")
  end

  def send_disconnect_notification(user)
    send_notification(current_user.id, user.id, "#{current_user.username} disconnected from you")
  end

  def send_reject_request_notification(user_id)
    user = User.find(user_id)
    send_notification(current_user.id, user.id, "#{current_user.username} rejected your connection request")
  end

  def send_accept_request_notification(user_id)
    user = User.find(user_id)
    send_notification(current_user.id, user.id, "#{current_user.username} accepted your connection request")
  end

  def send_job_post_creation_notification
    user = User.find_by(role: 'admin')
    send_notification(current_user.id, user.id, "Please review #{current_user.username} new job post")
  end

  def send_job_post_approve_notification(user_id)
    send_notification(current_user.id, user_id, 'Your job post is approved')
  end

  def send_new_chat_notification(user)
    send_notification(user.id, current_user.id, "#{user.username} started a conversation")
  end

  def send_new_post_notification(skills_required, job_provider_id)
    all_users_except_admins = User.where.not(role: 'admin').where.not(id: job_provider_id)
    requirement_skills = skills_required.split(',').map(&:strip)
    users_with_matching_skills = find_users_with_matching_skills(all_users_except_admins, requirement_skills)
    users_with_matching_skills.each do |user|
      send_notification(current_user.id, user.id, 'There is a job requirement post that matches your skills.')
    end
  end

  private

  def find_users_with_matching_skills(users, required_skills)
    users.select do |user|
      user_skills = user.skills.split(',').map(&:strip)
      (user_skills & required_skills).any?
    end
  end
end
