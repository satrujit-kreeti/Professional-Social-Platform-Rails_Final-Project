# frozen_string_literal: true

class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_#{params[:sender_id]}"
    puts "Subscribed to notification channel: notification_#{params[:sender_id]}"
  end

  def receive(data)
    Notification.create(sender_id: data['sender_id'], body: data['message'], recipient_id: data['recipient_id'])
  end
end
