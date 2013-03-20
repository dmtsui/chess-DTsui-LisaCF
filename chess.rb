require 'debugger'
require 'colorize'

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
    draw_screen
    debugger
    # gets
    # system("clear")
    # @white_pieces[11].move([3,3])
    # draw_screen
    # gets
    # system("clear") 
    # @white_pieces[11].move([4,3])
    # draw_screen
    # gets
    # system("clear")
    # @white_pieces[11].move([5,3])
    # draw_screen
    # gets
    # system("clear")
    # @white_pieces[11].move([6,4])
    # draw_screen
    # gets
    # system("clear")
    # draw_screen
    #  test_piece = @white_pieces[11]
    #  p "pawn is at new space :#{test_piece.location}"
    #  p "captured pieces :#{@captured.count}"
    # @spaces.each {|space| p "#{space.position}, #{space.color}, #{space.contains.class}-#{space.contains && space.contains.color}"}
    #@white_pieces.each {|piece| puts piece.display}
    #@black_pieces.each {|piece| puts piece.display}
    draw_screen
  end

  def generate_spaces
    64.times do |position|
      row = position / 8
      col = position % 8
      if ((row + col) % 2).odd?
        color = :light_white
      else
        color = :light_black
      end
      @spaces << SpaceNode.new([row,col], color)
    end
    @spaces.each {|space|space.add_neighbors(@spaces)}
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
  
  def draw_screen
    screen_array = []
    8.times do |row|
      temp_row = []
      8.times do |col|
        position = row * 8 + col
        space_render = (@spaces[position].contains && @spaces[position].contains.display) || " . "
        temp_row << space_render.colorize( :background => @spaces[position].color)
      end
      screen_array.unshift(temp_row)
    end
    puts "  " + ("A".."H").to_a.join("  ")
    screen_array.each_with_index do |row, index|
      puts "#{8-index}" + row.join("") + "#{8-index}" 
    end
    puts "  " + ("A".."H").to_a.join("  ")
  end  

end

class SpaceNode
  attr_accessor :color, :contains, :position, :neighbors
  def initialize(position, color)
    @position = position
    @color = color
    @neighbors = {}
  end

  def add_neighbors(spaces)
    position = @position[0] * 8 + @position[1]
    neighbors_positions = {}
    neighbors_positions[:left] = position - 1
    neighbors_positions[:right] = position + 1
    neighbors_positions[:top] = position + 8
    neighbors_positions[:bottom] = position - 8
    neighbors_positions[:topleft] = position + 8 - 1
    neighbors_positions[:topright] = position + 8 + 1
    neighbors_positions[:botleft] = position - 8 - 1
    neighbors_positions[:botright] = position - 8 + 1   

    no_top_edge(neighbors_positions, position)
    no_bottom_edge(neighbors_positions, position)
    no_left_edge(neighbors_positions, position)
    no_right_edge(neighbors_positions, position)
    #debugger
    neighbors_positions.each do |key , pos|
      @neighbors[key] = spaces[pos]
    end
  end

  def no_top_edge(neighbors_positions, position)
    if position / 8 == 7
      neighbors_positions.delete(:topleft)
      neighbors_positions.delete(:top)
      neighbors_positions.delete(:topright)
    end
  end

  def no_bottom_edge(neighbors_positions, position)
    if position / 8 == 0
      neighbors_positions.delete(:botleft)
      neighbors_positions.delete(:bottom)
      neighbors_positions.delete(:botright)
    end
  end

  def no_left_edge(neighbors_positions, position)
    if position % 8 == 0
      neighbors_positions.delete(:topleft)
      neighbors_positions.delete(:left)
      neighbors_positions.delete(:botleft)
    end
  end

  def no_right_edge(neighbors_positions, position)
    if position % 8 == 7
      neighbors_positions.delete(:topright)
      neighbors_positions.delete(:right)
      neighbors_positions.delete(:botright)
    end
  end

end

class Player

end

class Piece
  attr_accessor :color, :location, :board, :display
  def initialize(color, board)
    @color = color
    @board = board
    @display = " . "
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
    #debugger
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
    @display = (@color == :black && " \u265F ") || " \u2659 "
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
    @display = (@color == :black && " \u265C ") || " \u2656 "
  end
  def move
  end
end

class Bishop < Piece
  def initialize(color, board)
    super(color, board)
    @display = (@color == :black && " \u265D ") || " \u2657 "
  end
  def move
  end
end
class Knight < Piece
  def initialize(color, board)
    super(color, board)
    @display = (@color == :black && " \u265E ") || " \u2658 "
  end
  def move
  end
end

class Queen < Piece
  def initialize(color, board)
    super(color, board)
    @display = (@color == :black && " \u265B ") || " \u2655 "
  end
  def move
  end
end

class King < Piece
  attr_accessor :color
  def initialize(color, board)
    super(color, board)
    @display = (@color == :black && " \u265A ") || " \u2654 "
  end
  def move(move_to)
    position = move_to[0] * 8 + move_to[1]
    if valid_move?(move_to)
      capture_piece(position) if has_piece_to_capture?(position)
      @location.contains = nil
      @location.display = "."
      @board.spaces[position].contains = self
      @location = @board.spaces[position]
      @location.display = @display
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
    #p "possible moves : #{possible_moves}"
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
