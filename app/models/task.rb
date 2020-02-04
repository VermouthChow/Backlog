class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 20 }
  validates :content, :priority_weight, :status, presence: true

  validate :content_maximum_words

  enum status: [ :open, :in_progress, :closed, :deleted ]

  PRIORITY = { 'urgent' => 100, 'important' => 50 }

  private
  def content_maximum_words
    errors.add(:content, "is too long(maximum words 40)") if content&.split(/\s+/).count > 40
  end

  def calculate_priority_weight(priority_list)
    priority_list.to_a.inject(0) { |sum, p| sum + PRIORITY[p].to_i }
  end
end
