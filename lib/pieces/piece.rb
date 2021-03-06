class Piece
  attr_reader :color, :pos

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @moved = nil
  end

  def color_eql?(input)
    color == ( input.is_a?(Symbol) ? input : input.color )
  end

  def color_opposite?(input)
    !color_eql?(input)
  end

  def move_to(end_pos, commit = false)
    @pos = end_pos
    commit && (@moved ||= board.turn_count)
  end

  def to_s
    color == :black ? self.symbol.colorize(:black) : self.symbol
  end

  def move_vectors
    raise NotImplementedError
  end

  attr_reader :board, :moved
  def diagonal_vectors
    [[1,1],[-1,1],[1,-1],[-1,-1]]
  end

  def orthogonal_vectors
    [[1,0],[0,1],[0,-1],[-1,0]]
  end

  def moves_in_direction_of(offset, attackable = true, limit = 7)
    moves = []

    until moves.length >= limit
      factor = moves.length + 1
      end_pt = [pos[0] + offset[0] * factor, pos[1] + offset[1] * factor]

      break if !board.on_board?(end_pt)
      if board.occupied?(end_pt)
        moves << end_pt if attackable && !board.can_move_into?(self, end_pt)
        break
      end

      moves << end_pt
    end

    moves
  end
end

require_relative 'steppable.rb'
require_relative 'slideable.rb'

require_relative 'pawn.rb'
require_relative 'king.rb'
require_relative 'queen.rb'
require_relative 'rook.rb'
require_relative 'knight.rb'
require_relative 'bishop.rb'
