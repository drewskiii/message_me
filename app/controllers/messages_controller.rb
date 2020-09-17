class MessagesController < ApplicationController
    before_action :require_user
    
    def create
        message = current_user.messages.build(message_params)  # we have current_user bc we enforce in before_action
        if message.save
            ActionCable.server.broadcast 'chatroom_channel', 
                    mod_message: message_render(message) # will transmit a hash to chatroom.coffee (recieved)
        end
    end

    private
    
    def message_params
        params.require(:message).permit(:body)
    end

    def message_render(message)
        render(partial: 'message', locals: {message: message})  # use locals for _message partial to recognize message 
    end

end
