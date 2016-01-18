class Team < ActiveRecord::Base
  validates :city, :name, :league, :division, :stadium, :capacity, presence: true
  has_many :players
end
