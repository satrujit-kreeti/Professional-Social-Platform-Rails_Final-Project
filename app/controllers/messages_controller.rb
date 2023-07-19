class MessagesController < ApplicationController
    def create
      @conversation = Conversation.find(params[:conversation_id])
      @message = @conversation.messages.build(message_params)
      @message.sender = current_user
      @message.recipient = @conversation.opposed_user(current_user)
  
      if @message.save
        broadcast_chat(@message, @conversation)
      else
        render 'conversations/show'
      end
    end
  
    private
  
    def message_params
      params.require(:message).permit(:body)
    end
  
    def broadcast_chat(message, conversation)
      ActionCable.server.broadcast("chat_#{conversation.id}", {
            sender: message.sender.username,
            message: message.body
        })
    end
end