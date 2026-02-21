class Pack < ApplicationRecord
  belongs_to :user_medication

  has_many :doses
end
