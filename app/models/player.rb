class Player < ActiveRecord::Base
  validates :team, :first_name, :last_name, :age, :height, :weight, :position, :salary, presence: true
  belongs_to :team

  def full_name
    first_name + ' ' + last_name
  end

end
