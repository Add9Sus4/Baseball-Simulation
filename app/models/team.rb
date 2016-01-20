class Team < ActiveRecord::Base
  validates :city, :name, :league, :division, :stadium, :capacity, presence: true
  has_many :players, :dependent => :destroy

  def full_name
    city + ' ' + name
  end

end
