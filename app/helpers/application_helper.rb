module ApplicationHelper

  def drop_leading_zero(num)
    num.to_s.first == '0' ? num.to_s[1..-1].to_f : num
  end

end
