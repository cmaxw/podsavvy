class MessagesController < ApplicationController
  def create
    @user_message = Message.create!(message_params.merge(role: "user"))

    ai_agent = RubyLLM.chat
    weather_tool = WeatherTool.new
    ai_agent.with_tool(weather_tool)
    ai_message = ai_agent.ask(@user_message.content)

    @ai_message = Message.create!(
      content: ai_message.content,
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
