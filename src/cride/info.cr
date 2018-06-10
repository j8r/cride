struct Cride::Info
  @fg_info_color : Int32
  @bg_info_color : Int32
  @height : Int32 = TermboxBindings.tb_height
  @width = 0

  def initialize(@fg_info_color, @bg_info_color)
  end

  def write(char)
    TermboxBindings.tb_change_cell @width, @height, char, @fg_info_color, @bg_info_color
    @width += 1
  end

  def render_number(cursor)
    cursor.to_s.each_char do |char|
      write char.ord
    end
  end

  def render
    @height = TermboxBindings.tb_height - 1

    # y: cursor.y / Total rows
    write 121
    write 58
    render_number Editor.cursor.y + 1
    write 47
    render_number Editor.rows.size

    # space
    write 32

    # x: cursor.x / Total line characters
    write 120
    write 58
    render_number Editor.cursor.x + 1
    write 47
    render_number Editor.rows[Editor.cursor.y].size + 1

    # Render remaining empty characters
    while @width < TermboxBindings.tb_width
      write 32
    end

    # Reset width
    @width = 0
  end
end
