struct Cride::Editor::Info
  @height : Int32 = TermboxBindings.tb_height - 1
  @width = 0

  def initialize
    render
  end

  private def write(char, fg = E.color.fg_info)
    TermboxBindings.tb_change_cell @width, @height, char, fg, E.color.bg_info
    @width += 1
  end

  private def render_string(str, fg = E.color.fg_info)
    str.each_char do |char|
      write char.ord, fg
    end
  end

  private def line
    # y: cursor.y / Total rows
    write 121
    write 58
    render_string (Editor.absolute_y + 1).to_s
    write 47
    render_string Editor.rows.size.to_s

    # space
    write 32

    # x: cursor.x / Total line characters
    write 120
    write 58
    render_string (Editor.absolute_x + 1).to_s
    write 47
    render_string (Editor.rows[Editor.absolute_y].size + 1).to_s
  end

  private def render
    render_string Editor.file, (E.saved ? E.color.bg_info : E.color.not_saved)
    write 32
    line

    # Render remaining empty characters
    while @width < TermboxBindings.tb_width
      write 32
    end
  end
end
