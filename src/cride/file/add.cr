struct Cride::FileHandler::Add
  @rows : Array(Array(Char))
  @saved : Pointer(Bool)

  def initialize(@rows, @saved)
  end

  def char(x, y, char)
    @rows[y].insert x, char
    @saved.value = false
  end

  def line(x, y)
    old = @rows[y]

    # Remove the character after the cursor
    new_array = old.pop old.size - x

    # Append to the new array
    @rows.insert y + 1, new_array
    @saved.value = false
  end

  def duplicate_line(x, y)
    @rows.insert y + 1, @rows[y].dup
    @saved.value = false
  end
end
