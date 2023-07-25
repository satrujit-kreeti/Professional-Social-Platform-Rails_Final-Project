# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(recipient_id: current_user.id).all
  end

  def mark_all_as_read
    @notification = Notification.where(recipient_id: current_user.id).all
    @notification.update_all(read: true)
    render json: { message: 'All notifications marked as read.' }, status: :ok
  end
end
