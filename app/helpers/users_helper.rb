# frozen_string_literal: true

module UsersHelper
  def find_friendship
    current_user.friendships.find_by(friend_id: @user.id)
  end

  def destroy_friendship(friendship)
    friendship.destroy
  end

  def redirect_after_disconnect
    if request.referer.include?('profiles')
      render :profiles
    else
      redirect_to user_connections_path(current_user)
    end
  end

  def user_already_connected?
    current_user.friends.include?(@user)
  end

  def create_or_update_friendship
    friendship = current_user.friendships.find_or_initialize_by(friend_id: @user.id)
    friendship.update(connected: false, requested_by_user_id: current_user.id)
  end

  def delete_friendships
    @user.friendships.destroy_all
    Friendship.where(friend: @user).destroy_all
  end

  def delete_posts
    @user.posts.destroy_all
  end

  def purge_attachments
    @user.profile_photo.purge if @user.profile_photo.attached?
    @user.cv.purge if @user.cv.attached?
  end

  def destroy_certificates
    @user.certificates.destroy_all
  end

  def redirect_after_deletion
    if current_user.admin?
      redirect_to users_list_path, notice: 'User account deleted successfully.'
    else
      notice_message = 'Your account has been deleted. Create a new account to use our app.'
      redirect_to root_path, notice: notice_message, status: :see_other
    end
  end

  def redirect_to_error(error)
    redirect_to root_path, alert: 'An error occurred while deleting your account. Please try again.',
                           status: :see_other
    raise error
  end

  def attach_certificates_documents
    params[:user][:certificates_documents].each do |document|
      @user.certificates.build(certificate_document: document)
    end
  end

  def create_and_import_elasticsearch_index
    User.__elasticsearch__.create_index!(force: true)
    User.import
    if @user.save
      redirect_to login_path, notice: 'User created successfully. Please log in'
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :new
    end
  end
end
