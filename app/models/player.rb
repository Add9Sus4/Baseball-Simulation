class Player < ActiveRecord::Base
  validates :team, :first_name, :last_name, :age, :height, :weight, :position, :salary, presence: true
  belongs_to :team

  def full_name
    first_name + ' ' + last_name
  end

  def average_fielding
    (fieldGrounder + fieldLiner + fieldFlyball + fieldPopup)/4
  end

  def average_throwing
    (throwShort + throwMedium + throwLong)/3
  end

end
