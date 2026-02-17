class AssistentTalk < ApplicationRecord
  belongs_to :user

  enum :talk, {
    introduction: 0
  }
end
