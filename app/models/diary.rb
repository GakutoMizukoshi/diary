class Diary < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true
  validates :send_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  
end
