class Referral < ActiveRecord::Base
  belongs_to :contact
  has_many :events, as: :associated

  validates :contact, presence: true
  validates :name, presence: true
  validates :email, presence: true
end
