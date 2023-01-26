class Contact < ActiveRecord::Base
  has_many :referrals
  has_many :events

  validates :name, presence: true
  validates :email, presence: true
  validates :points, numericality: { positive: true }
end
