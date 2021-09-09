module RatingHelper
  # Calculates the number of full, half and empty star icons required to display
  # the specified rating. Yields [full, half, empty] to a block and/or returns it.
  def rating_stars(stars, out_of:)
    halves = (stars * 2).round
    half = halves % 2
    full = halves.div(2)
    empty = out_of - full - half

    if block_given?
      yield full, half, empty
    end

    [full, half, empty]
  end
end
