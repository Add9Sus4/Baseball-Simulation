module ApplicationHelper

  # Takes number 1 through 100 and prints zone number
  def table_index_to_zone(index)
    case index
    when 1..3, 11, 21
      1
    when 4..7
      2
    when 8..10, 20, 30
      3
    when 12..19
      index - 8
    when 22..29
      index - 10
    when 32..39
      index - 12
    when 31, 41, 51, 61
      28
    when 42..49
      index - 13
    when 40, 50, 60, 70
      37
    when 52..59
      index - 14
    when 62..69
      index - 16
    when 72..79
      index - 18
    when 82..89
      index - 20
    when 71, 81, 91..93
      70
    when 94..97
      71
    when 80, 90, 98..100
      72
    end

  end

  def reset_player_stats
    Player.update_all({atbats: 0,
                        runs: 0,
                        hits: 0,
                        doubles: 0,
                        triples: 0,
                        home_runs: 0,
                        rbi: 0,
                        walks: 0,
                        strikeouts: 0,
                        stolen_bases: 0,
                        caught_stealing: 0,
                        errors_committed: 0,
                        assists: 0,
                        putouts: 0,
                        chances: 0,
                        outs_recorded: 0,
                        hits_allowed: 0,
                        runs_allowed: 0,
                        earned_runs_allowed: 0,
                        walks_allowed: 0,
                        strikeouts_recorded: 0,
                        home_runs_allowed: 0,
                        total_pitches: 0,
                        strikes_thrown: 0,
                        balls_thrown: 0,
                        intentional_walks_allowed: 0})
  end

  def zero_if_nan(num)
    if num.nan?
      0.000
    else
      num
    end
  end

  def drop_leading_zero(num)
    if num.nan?
      0.000
    else
      num.to_s.first == '0' ? num.to_s[1..-1].to_f : num
    end
  end

end
