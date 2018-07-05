struct Cride::Terminal::Info
  @width = 0
  @height : Int32
  @editor : Cride::Editor
  @color : Color

  def initialize(@editor, @color)
    @height = @editor.size.height + 1
  end

  private def write(char, fg = @color.fg_info)
    TermboxBindings.tb_change_cell @width, @height, char, fg, @color.bg_info
    @width += 1
  end

  private def render_string(str, fg = @color.fg_info)
    str.each_char do |char|
      write char.ord, fg
    end
  end

  private def line
    # y: cursor_y / Total rows
    write 121
    write 58
    render_string (@editor.position.absolute_y + 1).to_s
    write 47
    render_string @editor.file.rows.size.to_s

    # space
    write 32

    # x: cursor_x / Total line characters
    row = @editor.file.rows[@editor.position.absolute_y]
    write 120
    write 58

    render_string (@editor.position.absolute_x + 1 + @editor.tab_before_absolute_width row).to_s
    write 47
    render_string (row.size + 1 + @editor.tab_width row).to_s
  end

  def render
    render_string @editor.file.name, (@editor.file.saved ? @color.bg_info : @color.unsaved)
    write 32
    line

    # Render remaining empty characters
    editor_width = @editor.size.width + 1
    while @width < editor_width
      write 32
    end
    @width = 0
  end
end
