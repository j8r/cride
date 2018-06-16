struct Cride::FileHandler::Add
  @rows : Array(Array(Char))
  @saved : Bool

  def initialize(@rows, @saved)
  end

  def char(x, y, char)
    @rows[y].insert x, char
    @saved = false
  end

  def line(x, y)
    old = @rows[y]

    # Remove the character after the cursor
    new_array = old.pop old.size - x

    # Append to the new array
    @rows.insert y + 1, new_array
    @saved = false
  end

  def duplicate_line(x, y)
    @rows.insert y + 1, @rows[y].dup
    @saved = false
  end
end
