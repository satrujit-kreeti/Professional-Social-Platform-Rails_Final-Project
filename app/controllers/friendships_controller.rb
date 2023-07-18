class FriendshipsController < ApplicationController

    def pending_requests
      @users = User.where(role: 'user')
      @user = current_user
      @pending_requests = Friendship.where(friend_id: @user.id, connected: false)
    end
  
    def approve
      @friendship = Friendship.find(params[:id])
      send_accept_request_notification(@friendship.user_id)
      @friendship.update(connected: true)
      redirect_to pending_requests_path, notice: "Friendship request approved."
    end
  
    def reject
      @friendship = Friendship.find(params[:id])
      send_reject_request_notification(@friendship.user_id)
      @friendship.destroy

      redirect_to pending_requests_path, notice: "Friendship request rejected."
    end
  

end
  