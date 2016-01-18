class Player < ActiveRecord::Base
  belongs_to :team

  def full_name
    first_name + ' ' + last_name
  end

end
