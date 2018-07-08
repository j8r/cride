struct Cride::Terminal::Render
  @editor : Cride::Editor
  @color : Color

  def initialize(@editor, @color)
  end

  private def cell_color(x, y) : String
    if y == @editor.position.cursor_y
      # highlight the selected line
      if x == @editor.cursor_x_with_tabs
        # cursor position
        if @editor.insert
          @color.ansi_foreground(@color.bg_cursor_num, Color::Mode::Underline) + @color.bg_line
        else
          @color.fg_cursor + @color.bg_cursor
        end
      else
        @color.fg_line + @color.bg_line
      end
    else
      @color.fg + @color.bg
    end
  end

  def editor
    # Render starting at the page_y line until the end of the terminal height
    String.build do |str|
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
                str << cell_color(x, y) << ' '
                x += 1
              end
            else
              str << cell_color(x, y) << char
              x += 1
            end
          end
        end
        if x == @editor.cursor_x_with_tabs && y == @editor.position.cursor_y
          str << cell_color(x, y) << ' '
          x += 1
        end
        str << cell_color(x, y) << fill_line x
        y += 1
      end
      # Fill remaining empty rows
      (@editor.size.height + 1 - y).times do
        str << @color.fg + @color.bg << fill_line 0
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
    @color.bg_info \
      + (@editor.file.saved ? @color.bg_info : @color.unsaved) \
      + @editor.file.name \
      + @color.fg_info \
      + position \
      + fill_line (@editor.file.name + position).size
  end

  # Fill remainig cells with spaces
  def fill_line(line_size)
    String.build do |str|
      (@editor.size.width + 1 - line_size).times do
        str << ' '
      end
    end
  end
end
