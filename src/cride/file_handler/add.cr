struct Cride::FileHandler::Add
  @rows : Array(String)
  @saved : Pointer(Bool)

  def initialize(@rows, @saved)
  end

  def char(x, y, char)
    @rows[y] = @rows[y].insert x, char
    @saved.value = false
  end

  def set_char(x, y, char)
    line = @rows[y]
    @rows[y] = if line.size > x
                 line.sub x, char
               else
                 line + char
               end
    @saved.value = false
  end

  def line(x, y)
    old_row = @rows[y]

    # Split the line in two
    @rows[y], new_row = old_row[0...x], old_row[x..-1]

    # Append to the new array
    @rows.insert y + 1, new_row
    @saved.value = false
  end

  def duplicate_line(y)
    @rows.insert y + 1, @rows[y].dup
    @saved.value = false
  end
end
