class Transaction < ActiveRecord::Base
  belongs_to :team

  def description
    case transaction_type
    when "Draft"
      @player = Player.find(drafted_player_id)
      "#{transaction_date.strftime("%B %e, %Y")}: The #{team.full_name} draft #{@player} (Round #{@player.draft_round}, ##{@player.draft_position})."
    when "Promotion"
      "#{transaction_date.strftime("%B %e, %Y")}: The #{team.full_name} promote #{Player.find(promoted_player_id)} and drop #{Player.find(dropped_player_id)}."
    when "Signing"
      if dropped_player_id != nil
        "#{transaction_date.strftime("%B %e, %Y")}: The #{team.full_name} sign #{Player.find(signed_player_id)} and drop #{Player.find(dropped_player_id)}."
      else
        "#{transaction_date.strftime("%B %e, %Y")}: The #{team.full_name} sign #{Player.find(signed_player_id)}."
      end
    end
  end

end
