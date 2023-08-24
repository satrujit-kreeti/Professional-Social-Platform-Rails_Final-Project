# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :check_admin

  def pending_requests
    @users = User.where(role: 'user')
    @user = current_user
    @pending_requests = Friendship.where(friend_id: @user.id, connected: false)
  end

  def approve
    @friendship = Friendship.find(params[:id])
    send_accept_request_notification(@friendship.user_id)
    @friendship.update(connected: true)
    redirect_to pending_requests_friendships_path, notice: 'Friendship request approved.'
  end

  def reject
    @friendship = Friendship.find(params[:id])
    send_reject_request_notification(@friendship.user_id)
    @friendship.destroy

    redirect_to pending_requests_friendships_path, notice: 'Friendship request rejected.'
  end

  private

  def check_admin
    return unless current_user&.admin?

    redirect_to home_users_path, alert: 'Admins are not allowed to access this page.'
  end
end
