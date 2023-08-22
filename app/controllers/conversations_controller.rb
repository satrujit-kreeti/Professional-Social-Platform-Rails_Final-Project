# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :check_admin
  before_action :restrict_messages, only: [:show]

  def index
    @conversations = current_user.sent_conversations.or(current_user.received_conversations)
  end

  def new
    recipient = User.find(params[:recipient_id])
    conversation = Conversation.between(current_user, recipient).first
    conversation ||= Conversation.create(sender: current_user, recipient:)

    redirect_to conversation_path(conversation)
  end

  def create
    recipient = User.find(params[:conversation][:recipient_id])
    conversation = Conversation.between(current_user, recipient).first
    conversation ||= Conversation.create(sender: current_user, recipient:)

    redirect_to conversation
  end

  def show
    @conversation = Conversation.find(params[:id])
    @conversation.messages.where(read: false).where.not(sender_id: current_user.id).update_all(read: true)
    @message = Message.new
  end

  private

  def restrict_messages
    if Conversation.exists?(params[:id])
      if_exist
    else
      redirect_to conversations_path, alert: 'Conversation doesnt exist'
    end
  end

  def if_exist
    @id = Conversation.find(params[:id])
    return unless @id.sender_id != current_user.id && @id.recipient_id != current_user.id

    redirect_to conversations_path, alert: 'Cannot show messages'
  end

  def check_admin
    redirect_to home_path, notice: 'Access denied, admins can\'t perform this action.' if current_user&.admin?
  end
end
