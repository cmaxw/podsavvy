class MessagesController < ApplicationController
  def create
    @user_message = Message.create!(message_params.merge(role: "user"))
    
    # Simulate AI response (replace with actual AI logic)
    @ai_message = Message.create!(
      content: "This is a sample AI response to: '#{@user_message.content}'",
      role: "ai"
    )

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
