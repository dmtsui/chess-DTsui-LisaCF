require 'debugger'
class ChessGame
end

class Board
  attr_accessor :spaces, :white_pieces, :black_pieces, :captured

  def initialize
    @spaces = []
    @captured = []
    @white_pieces = []
    @black_pieces = []
    generate_spaces
    generate_pieces(@white_pieces, :white)
    generate_pieces(@black_pieces, :black).reverse!
    @black_pieces[11], @black_pieces[12] = @black_pieces[12], @black_pieces[11]
    set_pieces(@white_pieces, :white)
    set_pieces(@black_pieces, :black)
  end

  def play
    @white_pieces[11].move([3,3])
    @white_pieces[11].move([4,3])
    @white_pieces[11].move([5,3])
    @white_pieces[11].move([6,3])

    test_piece = @white_pieces[11]
    p "pawn is at new space :#{test_piece.location}"
     p "captured pieces :#{@captured.count}"
    @spaces.each {|space| p "#{space.position}, #{space.color}, #{space.contains.class}-#{space.contains && space.contains.color}"}
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
    piece_array << Rook.new(color, self)
    piece_array << Knight.new(color, self)
    piece_array << Bishop.new(color, self)
    piece_array << Queen.new(color, self)
    piece_array << King.new(color, self)
    piece_array << Bishop.new(color, self)
    piece_array << Knight.new(color, self)
    piece_array << Rook.new(color, self)
    8.times do
      piece_array << Pawn.new(color, self)
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

class Piece
  attr_accessor :color, :location, :board
  def initialize(color, board)
    @color = color
    @board = board
  end

  def location
    @location.position
  end

  def location=(space_node)
    @location = space_node
  end

  def is_space_open?(move_to)
    position = move_to[0] * 8 + move_to[1]
    if @board.spaces[position].contains and @board.spaces[position].contains.color == @color
      false
    else
      true
    end
  end

  def capture_piece(position)
    debugger
    @board.captured << @board.spaces[position].contains
  end

  def has_piece_to_capture?(position)
    if @board.spaces[position].contains and @board.spaces[position].contains.color != @color
      true
    else
      false
    end
  end

end

class Pawn < Piece
  attr_accessor :color
  def initialize(color, board)
    super(color, board)
  end
  def move(move_to)
    position = move_to[0] * 8 + move_to[1]
    if valid_move?(move_to)
      capture_piece(position) if has_piece_to_capture?(position)
      @location.contains = nil
      @board.spaces[position].contains = self
      @location = @board.spaces[position]
    else
      p "Invalid Move!"
    end
  end

  def is_blocked?(move_to)
    position = move_to[0] * 8 + move_to[1]
    if @board.spaces[position].contains
      true
    else
      false
    end
  end


  def valid_move?(move_to)
    position = move_to[0] * 8 + move_to[1]
    possible_moves = []
    if @color == :white
      possible_moves += [[1, 0]] unless is_blocked?(move_to)
      possible_moves += [[2,0]] if location[0] == 1  and !is_blocked?(move_to)
      possible_moves += [[1, -1], [1, 1]] if has_piece_to_capture?(position)
    else
      possible_moves += [[-1, 0]] unless is_blocked?(move_to)
      possible_moves += [[-2,0]] if location[0] == 6 and !is_blocked?(move_to)
      possible_moves += [[-1, -1], [-1, 1]] if has_piece_to_capture?(position)
    end

    possible_moves.map! {|pos| [pos[0]+location[0], pos[1]+location[1]]}
    possible_moves.select! do |pos|
      pos if (0..7).include?(pos[0]) and (0..7).include?(pos[1])
    end
    p "move #{move_to} possible moves = #{possible_moves}"

    is_space_open?(move_to) && possible_moves.include?(move_to)
  end
end

class Rook < Piece
  def initialize(color, board)
    super(color, board)
  end
  def move
  end
end

class Bishop < Piece
  def initialize(color, board)
    super(color, board)
  end
  def move
  end
end
class Knight < Piece
  def initialize(color, board)
    super(color, board)
  end
  def move
  end
end

class Queen < Piece
  def initialize(color, board)
    super(color, board)
  end
  def move
  end
end

class King < Piece
  attr_accessor :color
  def initialize(color, board)
    super(color, board)
  end
  def move(move_to)
    position = move_to[0] * 8 + move_to[1]
    if valid_move?(move_to)
      capture_piece(position) if has_piece_to_capture?(position)
      @location.contains = nil
      @board.spaces[position].contains = self
      @location = @board.spaces[position]
    else
      p "Invalid Move!"
    end
  end

  def valid_move?(move_to)
    possible_moves = [-1,1,0,-1,1].permutation(2).to_a.uniq - [[0,0]]
    possible_moves.map! {|pos| [pos[0]+location[0], pos[1]+location[1]]}
    possible_moves.select! do |pos|
      pos if (0..7).include?(pos[0]) and (0..7).include?(pos[1])
    end
    p "possible moves : #{possible_moves}"
    is_space_open?(move_to) && possible_moves.include?(move_to)
  end

end


board = Board.new

board.play

# board.white_pieces.each do |piece|
# #  p "#{piece.class}, #{piece.color}, #{piece.location}"
# end
# board.black_pieces.each do |piece|
# #  p "#{piece.class}, #{piece.color}, #{piece.location}"
# end
#board.spaces.each {|space| p "#{space.position}, #{space.color}, #{space.contains.class}"}
