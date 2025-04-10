class Message < ApplicationRecord
  validates :content, presence: true

  def user_message?
    role == "user"
  end

  def ai_message?
    role == "assistant"
  end
end
