struct Cride::FileHandler::Add
  @rows : Array(String)
  @saved : Pointer(Bool)

  def initialize(@rows, @saved)
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

  def char(x, y, char)
    @rows[y] = @rows[y].insert x, char
    @saved.value = false
  end

  def line(x, y)
    old = @rows[y]
    old_size = old.size

    # Remove the character after the cursor
    new_row = old[x..-1]
    @rows[y] = old[0...x]

    # Append to the new array
    @rows.insert y + 1, new_row
    @saved.value = false
  end

  def duplicate_line(x, y)
    @rows.insert y + 1, @rows[y].dup
    @saved.value = false
  end
end
