# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here

  # your enhancements here
  All_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]], # square (only needs one)
                rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
                [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
                 [[0, 0], [0, -1], [0, 1], [0, 2]]],
                rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
                rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
                rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
                rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
                [[[0, 0], [-1, 0], [1, 0], [2, 0], [2, 0]],
                 [[0, 0], [0, -1], [0, 1], [0, -2], 0, 2]], # bf added extra long 5 piecer (only needs two)
                rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2, 0]]), # bf added square + extra
                rotations([[0, 0], [1, 0], [0, 1]])]

  def number_of_blocks
    #all_rotations holds point array. this gets how many array elements are in the first rotation, which equals how many blocks there are
    @all_rotations[0].size
  end

  def self.next_piece (board, cheat)
    if cheat
      MyPiece.new([[[0, 0]]], board)
    else
      MyPiece.new(All_Pieces.sample, board)
    end
  end
end

class MyBoard < Board
  # your enhancements here
  def initialize (game)
    @grid = Array.new(num_rows) { Array.new(num_columns) }
    @current_block = MyPiece.next_piece(self, false)
    @score = 0
    @game = game
    @delay = 500
    @cheat = false
  end

  def score=(new_score)
    @score = new_score
  end

  def activate_cheat
    if (score >= 100 && @cheat == false) #second condition prevents error upon multiple presses of c
      @cheat = true
      self.score-= 100
    end
  end

  def deactivate_cheat
    @cheat = false
  end

  def rotate_180
    rotate_clockwise
    rotate_clockwise
  end

  def next_piece
    @current_block = MyPiece.next_piece(self, @cheat)
    @current_pos = nil
    deactivate_cheat
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(@current_block.number_of_blocks - 1)).each { |index|
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
        @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  # your enhancements here
  # creates a canvas and the board that interacts with it
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    @root.bind('n', proc { self.new_game })

    @root.bind('p', proc { self.pause })

    @root.bind('q', proc { exitProgram })

    @root.bind('a', proc { @board.move_left })
    @root.bind('Left', proc { @board.move_left })

    @root.bind('d', proc { @board.move_right })
    @root.bind('Right', proc { @board.move_right })

    @root.bind('s', proc { @board.rotate_clockwise })
    @root.bind('Down', proc { @board.rotate_clockwise })

    @root.bind('w', proc { @board.rotate_counter_clockwise })
    @root.bind('Up', proc { @board.rotate_counter_clockwise })

    @root.bind('u', proc { @board.rotate_180 })

    @root.bind('c', proc { @board.activate_cheat })

    @root.bind('space', proc { @board.drop_all_the_way })
  end
end


