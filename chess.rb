class ChessGame
end

class Board
  attr_accessor :spaces, :white_pieces, :black_pieces

  def initialize
    @spaces = []
    generate_spaces
    @white_pieces = []
    @black_pieces = []
    generate_pieces(@white_pieces, :white)
    generate_pieces(@black_pieces, :black).reverse!
    @black_pieces[11], @black_pieces[12] = @black_pieces[12], @black_pieces[11]
    set_pieces(@white_pieces, :white)
    set_pieces(@black_pieces, :black)


     # white_pieces[0].location = @spaces[8]
  end



  def generate_spaces
    64.times do |position|
      row = position / 8
      col = position % 8
      if ((row + col) % 2).odd?
        color = :white
      else
        color = :black
      end
      @spaces << SpaceNode.new([row,col], color)
    end
  end
  def generate_pieces(piece_array, color)
    piece_array << Rook.new(color)
    piece_array << Knight.new(color)
    piece_array << Bishop.new(color)
    piece_array << Queen.new(color)
    piece_array << King.new(color)
    piece_array << Bishop.new(color)
    piece_array << Knight.new(color)
    piece_array << Rook.new(color)
    8.times do
      piece_array << Pawn.new(color)
    end
    piece_array
  end
  def set_pieces(piece_array, color)
    k = (color == :black && 48) || 0
    piece_array.count.times do |i|
      piece_array[i].location=@spaces[i+k]
      @spaces[i+k].contains = piece_array[i]
     end
  end
  # set initial position of pieces
end

class SpaceNode
  attr_accessor :color, :contains, :position
  def initialize(position, color)
    @position = position
    @color = color
  end

end

class Player

end

class Pieces
  attr_accessor :color, :location
  def initialize(color)
    @color = color
  end

  def location
    @location.position
  end

  def location=(space_node)
    @location = space_node
  end

end

class Pawn < Pieces
  attr_accessor :color
  def initialize(color)
    super(color)
  end
  def move
  end
end

class Rook < Pieces
  def initialize(color)
    super(color)
  end
  def move
  end
end

class Bishop < Pieces
  def initialize(color)
    super(color)
  end
  def move
  end
end
class Knight < Pieces
  def initialize(color)
    super(color)
  end
  def move
  end
end

class Queen < Pieces
  def initialize(color)
    super(color)
  end
  def move
  end
end

class King < Pieces
  def initialize(color)
    super(color)
  end
  def move
  end
end


board = Board.new

board.white_pieces.each do |piece|
  p "#{piece.class}, #{piece.color}, #{piece.location}"
end
board.black_pieces.each do |piece|
  p "#{piece.class}, #{piece.color}, #{piece.location}"
end
board.spaces.each {|space| p "#{space.position}, #{space.color}, #{space.contains.class}"}
