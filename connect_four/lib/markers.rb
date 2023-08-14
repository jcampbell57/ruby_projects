module Markers
  # pink_circle
  def second_marker
    "\e[38;5;213m\u25cf\e[0m"
  end

  # green circle
  def player_marker
    "\e[38;5;84m\u25cf\e[0m"
  end

  # empty_circle
  def empty_marker
    "\u25cb"
  end
end
