class Cride::Editor
  def move_left
    case 0
    when .< @cursor_x
      # move the cursor left - there are still characters
      @cursor_x -= 1
    when .< @page_x
      # scroll the page to the left if it was previously scrolled
      @page_x -= 1
    when .< absolute_y
      # if there is an upper line go to the end of it
      move_up
      move_end_of_line
    end
  end

  def move_right
    if absolute_x < @file.rows[absolute_y].size
      # move to right if there are characters
      if @cursor_x < @width
        # still space to move the cursor
        @cursor_x += 1
      else
        # scroll the page to the right
        @page_x += 1
      end
    elsif absolute_y + 1 < @file.rows.size
      # else go to the next line if it exists
      reset_x
      move_down
    end
  end

  def move_up
    case 0
    when absolute_y
      reset_x
    when .< @cursor_y
      # move if there is an upper row
      @cursor_y -= 1
      adapt_end_line
    when .< @page_y
      # if the page was already scrolled
      @page_y -= 1
      adapt_end_line
    end
  end

  def move_down
    case absolute_y <=> (rows_size = @file.rows.size - 1)
    when 0
      # end of the file
      @cursor_x = @file.rows[rows_size].size
    when -1
      # move if there is a row bellow
      if @cursor_y >= @height
        # scroll the page down if the height limit it reached
        @page_y += 1
        adapt_end_line
      else
        # else only move the cursor
        @cursor_y += 1
        adapt_end_line
      end
    end
  end

  def move_page_up
    if absolute_y == 0
      reset_x
    elsif @page_y > @height
      # enough to scroll up
      @page_y -= @height
      adapt_end_line
    else
      reset_y
      adapt_end_line
    end
  end

  def move_page_down
    case (rows_size = @file.rows.size - 1)
    when absolute_y
      move_end_of_line
    when .> @page_y + @height
      # enough to scroll down
      @page_y += @height
      adapt_end_line
    when .> @height
      # near the end of file
      @page_y = rows_size - @height
      @cursor_y = @height
      adapt_end_line
    else
      # at the end of file - only move the cursor
      @cursor_y = rows_size
      adapt_end_line
    end
  end

  # Blocks of text are separated by empty rows, or rows including only spaces/tabs.
  private def block_traverser(limit)
    # If we are in an empty line, go until we reach a non empty line
    while (absolute_y != limit) && empty_row?(@file.rows[absolute_y])
      yield
    end
    # When an non empty line is reached, go to the begining of the block
    while (absolute_y != limit) && !empty_row?(@file.rows[absolute_y])
      yield
    end
    move_down if absolute_y > 0
  end

  # Used for CTRL arrow up.
  def move_previous_block
    move_up
    block_traverser(0) { move_up }
  end

  # Used for CTRL arrow down.
  def move_next_block
    block_traverser(@file.rows.size - 1) { move_down }
  end

  # An 'empty' row consists of only spaces and/or tabs, or no chars.
  def empty_row?(row : String)
    row.each_char do |char|
      return false if char != ' ' && char != '\t'
    end
    true
  end

  private def word_traverser(diff)
    yield
    row = @file.rows[absolute_y]

    condition = ->(row : String) { absolute_y != absolute_x != 0 && absolute_x < row.size }

    if (char = row[absolute_x - diff]?) && char.alphanumeric?
      # Continue until a non alphanumeric character is found
      while condition.call(row) && (char = row[absolute_x - diff]?) && char.alphanumeric?
        yield
      end
    else
      # Continue until an alphanumeric character is found
      while condition.call(row) && (char = row[absolute_x - diff]?) && !char.alphanumeric?
        yield
      end
    end
  end

  # Used for CTRL arrow left.
  def move_previous_word
    word_traverser(1) { move_left }
  end

  # Used for CTRL arrow right.
  def move_next_word
    word_traverser(0) { move_right }
  end

  private def adapt_end_line
    if absolute_x > (line_size = @file.rows[absolute_y].size)
      # the line if smaller than the one before
      case line_size
      when 0
        # If the line is empty
        reset_x
      when .< @page_x
        # the page size of the former line is longer that the size of the current line - adapt it
        @page_x = line_size
        @cursor_x = 0
      else
        # only modify the cursor
        @cursor_x = line_size - @page_x
      end
    end
  end

  def move_end_of_line
    line_size = @file.rows[absolute_y].size
    if line_size > @width
      @page_x = line_size - @width
      @cursor_x = @width
    else
      @cursor_x = line_size
    end
  end
end
