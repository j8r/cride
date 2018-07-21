struct Cride::FileHandler::Delete
  @rows : Array(String)
  @saved : Pointer(Bool)

  def initialize(@rows, @saved)
  end

  def char(x, y)
    @rows[y] = @rows[y].sub(x, "")
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

  def clear_line(y)
    @rows[y] = ""
    @saved.value = false
  end

  def line(y)
    @rows.delete_at y
    @saved.value = false
  end
end
