struct Cride::Terminal::Render
  def initialize(@editor : Editor, @color : Color, @io : IO = STDOUT)
  end

  private def cell_color(x, y)
    if y == @editor.cursor_y
      # highlight the selected line
      if x == @editor.cursor_x_with_tabs
        # cursor position
        if @editor.insert
          @io << @color.ansi_foreground(@color.bg_cursor_num, Color::Mode::Underline) << @color.bg_line
        else
          @io << @color.fg_cursor << @color.bg_cursor
        end
      else
        @io << @color.fg_line << @color.bg_line
      end
    else
      @io << @color.fg << @color.bg
    end
  end

  def editor
    # Set the cursor at home (on the top left)
    @io << "\033[H"
    y = 0

    # Render starting at the page_y line until the end of the terminal height
    @editor.file.rows[@editor.page_y..@editor.page_y + @editor.height].each do |row|
      x = 0
      width = @editor.width + @editor.tab_width row
      # Start to render at the page_x until the end of the terminal width
      if row[@editor.page_x]?
        row[@editor.page_x..@editor.page_x + width].each_char do |char|
          # highlight current line
          if char == '\t'
            @editor.tab_spaces.times do
              cell_color x, y
              @io << ' '
              x += 1
            end
          else
            cell_color x, y
            @io << char
            x += 1
          end
        end
      end
      if x == @editor.cursor_x_with_tabs && y == @editor.cursor_y
        cell_color x, y
        @io << ' '
        x += 1
      end
      cell_color x, y
      fill_line x
      @io << '\n'
      y += 1
    end
    # Fill remaining empty rows
    (@editor.height + 1 - y).times do
      @io << @color.fg << @color.bg
      fill_line 0
      @io << '\n'
    end

    # Add the lower info line
    @io << info
    @io.flush
  end

  def info
    row = @editor.file.rows[@editor.absolute_y]
    position = String.build do |str|
      str << " y:"
      str << @editor.absolute_y + 1
      str << '/'
      str << @editor.file.rows.size
      str << " x:"
      str << @editor.absolute_x + 1 + @editor.tab_before_absolute_width row
      str << '/'
      str << row.size + 1 + @editor.tab_width row
    end
    # Return a colored info line
    if @editor.file.saved?
      @io << @color.bg_info << @color.fg_info
    else
      @io << @color.bg_unsaved << @color.fg_unsaved
    end
    @io << @editor.file.name
    @io << @color.bg_info << @color.fg_info
    @io << position
    fill_line (@editor.file.name.to_s + position).size
  end

  # Fill remainig cells with spaces
  def fill_line(line_size)
    (@editor.width + 1 - line_size).times do
      @io << ' '
    end
  end
end
