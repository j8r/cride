struct Cride::Editor::Move
  @file : Cride::FileHandler
  @position : Position
  @size : Cride::Size

  def initialize(@file, @position, @size)
  end

  def left
    case 0
    when .< @position.cursor_x
      # move the cursor left - there are still characters
      @position.cursor_x -= 1
    when .< @position.page_x
      # scroll the page to the left if it was previously scrolled
      @position.page_x -= 1
    when .< @position.absolute_y
      # if there is an upper line go to the end of it
      up
      end_of_line
    end
  end

  def right
    if @position.absolute_x < @file.rows[@position.absolute_y].size
      # move to right if there are characters
      if @position.cursor_x < @size.width
        # still space to move the cursor
        @position.cursor_x += 1
      else
        # scroll the page to the right
        @position.page_x += 1
      end
    elsif @position.absolute_y + 1 < @file.rows.size
      # else go to the next line if it exists
      @position.reset_x
      down
    end
  end

  def up
    case 0
    when @position.absolute_y
      @position.reset_x
    when .< @position.cursor_y
      # move if there is an upper row
      @position.cursor_y -= 1
      adapt_end_line
    when .< @position.page_y
      # if the page was already scrolled
      @position.page_y -= 1
      adapt_end_line
    end
  end

  def down
    case @position.absolute_y <=> (rows_size = @file.rows.size - 1)
    when 0
      # end of the file
      @position.cursor_x = @file.rows[rows_size].size
    when -1
      # move if there is a row bellow
      if @position.cursor_y >= @size.height
        # scroll the page down if the height limit it reached
        @position.page_y += 1
        adapt_end_line
      else
        # else only move the cursor
        @position.cursor_y += 1
        adapt_end_line
      end
    end
  end

  def page_up
    if @position.absolute_y == 0
      @position.reset_x
    elsif @position.page_y > @size.height
      # enough to scroll up
      @position.page_y -= @size.height
      adapt_end_line
    else
      @position.reset_y
      adapt_end_line
    end
  end

  def page_down
    case (rows_size = @file.rows.size - 1)
    when @position.absolute_y
      end_of_line
    when .> @position.page_y + @size.height
      # enough to scroll down
      @position.page_y += @size.height
      adapt_end_line
    when .> @size.height
      # near the end of file
      @position.page_y = rows_size - @size.height
      @position.cursor_y = @size.height
      adapt_end_line
    else
      # at the end of file - only move the cursor
      @position.cursor_y = rows_size
      adapt_end_line
    end
  end

  # Blocks of text are separated by empty rows, or rows including only spaces/tabs
  private def block_traverser(limit)
    # If we are in an empty line, go until we reach a non empty line
    while (@position.absolute_y != limit) && empty_row?(@file.rows[@position.absolute_y])
      yield
    end
    # When an non empty line is reached, go to the begining of the block
    while (@position.absolute_y != limit) && !empty_row?(@file.rows[@position.absolute_y])
      yield
    end
    down if @position.absolute_y > 0
  end

  # Used for CTRL arrow up
  def previous_block
    up
    block_traverser(0) { up }
  end

  # Used for CTRL arrow down
  def next_block
    block_traverser(@file.rows.size - 1) { down }
  end

  # An 'empty' row consists of only spaces and/or tabs, or no chars
  def empty_row?(row : String)
    row.each_char do |char|
      return false if char != ' ' && char != '\t'
    end
    true
  end

  private def go_to_word(y_limit, x_limit)
    yield
    condition = ->(y_limit : Int32, x_limit : Int32) { (@position.absolute_y == y_limit) && (@position.absolute_x == x_limit) }

    if (char = @file.rows[@position.absolute_y][@position.absolute_x - 1]?) && char.alphanumeric?
      # Continue until a non alphanumeric character is found
      while !condition.call(y_limit, x_limit) && (char = @file.rows[@position.absolute_y][@position.absolute_x - 1]?) && char.alphanumeric?
        yield
      end
    else
      # Continue until an alphanumeric character is found
      while !condition.call(y_limit, x_limit) && (char = @file.rows[@position.absolute_y][@position.absolute_x - 1]?) && !char.alphanumeric?
        yield
      end
    end
  end

  # Used for CTRL arrow left
  def previous_word
    go_to_word(0, 0) { left }
  end

  # Used for CTRL arrow right
  def next_word
    go_to_word(@file.rows.size - 1, @file.rows.last.size) { right }
  end

  def adapt_end_line
    if @position.absolute_x > (line_size = @file.rows[@position.absolute_y].size)
      # the line if smaller than the one before
      case line_size
      when 0
        # If the line is empty
        @position.reset_x
      when .< @position.page_x
        # the page size of the former line is longer that the size of the current line - adapt it
        @position.page_x = line_size
        @position.cursor_x = 0
      else
        # only modify the cursor
        @position.cursor_x = line_size - @position.page_x
      end
    end
  end

  def end_of_line
    line_size = @file.rows[@position.absolute_y].size
    if line_size > @size.width
      @position.page_x = line_size - @size.width
      @position.cursor_x = @size.width
    else
      @position.cursor_x = line_size
    end
  end
end
