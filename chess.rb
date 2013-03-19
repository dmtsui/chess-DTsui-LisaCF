class ChessGame
end

class Board
  attr_accessor :spaces

  def initialize
    @spaces = []
    generate_spaces
  end

  def generate_spaces
    64.times do |position|
      row = position / 8
      col = position % 8
      @spaces << SpaceNode.new([row,col])
    end
  end

end

class SpaceNode
  attr_accessor :color, :contains, :position
  def initialize(position)
    @position = position
    @color = :black
  end

end

class Player

end

class Pieces
end

class Pawn < Pieces
end

class Rook < Pieces
end

class Bishop < Pieces
end

class Queen < Pieces
end

class King < Pieces
end


board = Board.new

board.spaces.each {|space| p space.position}
