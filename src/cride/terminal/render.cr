struct Cride::Terminal::Render
  @editor : Cride::Editor
  @color : Color

  def initialize(@editor, @color)
  end

  private def cell_color(io, x, y)
    if y == @editor.position.cursor_y
      # highlight the selected line
      if x == @editor.cursor_x_with_tabs
        # cursor position
        if @editor.insert
          io << @color.ansi_foreground(@color.bg_cursor_num, Color::Mode::Underline) << @color.bg_line
        else
          io << @color.fg_cursor << @color.bg_cursor
        end
      else
        io << @color.fg_line << @color.bg_line
      end
    else
      io << @color.fg << @color.bg
    end
  end

  def editor
    # Render starting at the page_y line until the end of the terminal height
    String.build do |str|
      # Clean the screen and set the cursor at home (on the top left)
      str << "\033[2J\033[H"
      y = 0
      @editor.file.rows[@editor.position.page_y..@editor.position.page_y + @editor.size.height].each do |row|
        x = 0
        width = @editor.size.width + @editor.tab_width row
        # Start to render at the page_x until the end of the terminal width
        if row[@editor.position.page_x]?
          row[@editor.position.page_x..@editor.position.page_x + width].each_char do |char|
            # highlight current line
            if char == '\t'
              @editor.tab_spaces.times do
                cell_color str, x, y
                str << ' '
                x += 1
              end
            else
              cell_color str, x, y
              str << char
              x += 1
            end
          end
        end
        if x == @editor.cursor_x_with_tabs && y == @editor.position.cursor_y
          cell_color str, x, y
          str << ' '
          x += 1
        end
        cell_color str, x, y
        fill_line str, x
        str << '\n'
        y += 1
      end
      # Fill remaining empty rows
      (@editor.size.height + 1 - y).times do
        str << @color.fg + @color.bg
        fill_line str, 0
        str << '\n'
      end

      # Add the lower info line
      str << info
    end
  end

  def info
    row = @editor.file.rows[@editor.position.absolute_y]
    position = String.build do |str|
      str << " y:"
      str << @editor.position.absolute_y + 1
      str << '/'
      str << @editor.file.rows.size
      str << " x:"
      str << @editor.position.absolute_x + 1 + @editor.tab_before_absolute_width row
      str << '/'
      str << row.size + 1 + @editor.tab_width row
    end
    # Return a colored info line
    String.build do |str|
      if @editor.file.saved
        str << @color.bg_info << @color.fg_info
      else
        str << @color.bg_unsaved << @color.fg_unsaved
      end
      str << @editor.file.name
      str << @color.bg_info << @color.fg_info
      str << position
      fill_line str, (@editor.file.name + position).size
    end
  end

  # Fill remainig cells with spaces
  def fill_line(io, line_size)
    (@editor.size.width + 1 - line_size).times do
      io << ' '
    end
  end
end
