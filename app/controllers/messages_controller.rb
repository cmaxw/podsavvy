class MessagesController < ApplicationController
  def create
    @user_message = Message.create!(message_params.merge(role: "user"))
    
    # Simulate AI response (replace with actual AI logic)
    ai_agent = DispatcherAgent.new
    ai_agent.transcript << {role: "user", content: @user_message.content}
    ai_message = Commonmarker.to_html(ai_agent.chat_completion)

    @ai_message = Message.create!(
      content: ai_message,
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
