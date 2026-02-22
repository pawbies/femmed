class AssistentTalk < ApplicationRecord
  belongs_to :user

  validates :talk, presence: true

  enum :talk, {
    introduction: 0
  }, validate: true
end
