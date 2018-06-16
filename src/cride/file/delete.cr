struct Cride::FileHandler::Delete
  @rows : Array(Array(Char))
  @saved : Pointer(Bool)

  def initialize(@rows, @saved)
  end

  def char(x, y)
    @rows[y].delete_at x
    @saved.value = false
  end

  def line_append_previous(y)
    # delete the line and append the remaing characters to the upper line
    @rows[y] += @rows.delete_at y + 1
    @saved.value = false
  end

  def next_line_append_current(y)
    # delete the line and append the remaing characters to the upper line
    @rows[y] += @rows.delete_at y + 1
    @saved.value = false
  end

  def line(y)
    @rows[y].clear
    @saved.value = false
  end
end
