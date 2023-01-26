class Event < ActiveRecord::Base
  belongs_to :contact
  belongs_to :associated, polymorphic: true

  validates :contact, presence: true
  validates :points, numericality: { positive: true }
  validates :associated, presence: true
end
