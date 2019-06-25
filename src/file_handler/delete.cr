struct Cride::FileHandler::Delete
  def initialize(@rows : Array(String))
  end

  def char(x : Int32, y : Int32)
    @rows[y] = @rows[y].sub(x, "")
  end

  # Deletes the line and append the remaing characters to the previous
  def next_line_append_previous(y : Int32)
    @rows[y] += @rows.delete_at y + 1
  end

  def clear_line(y : Int32)
    @rows[y] = ""
  end

  def line(y : Int32)
    @rows.delete_at y
  end
end
