struct Cride::FileHandler::Add
  def initialize(@rows : Array(String))
  end

  def char(x : Int32, y : Int32, char : Char)
    @rows[y] = @rows[y].insert x, char
  end

  def set_char(x : Int32, y : Int32, char : Char)
    line = @rows[y]
    @rows[y] = if line.size > x
                 line.sub x, char
               else
                 line + char
               end
  end

  def line(x : Int32, y : Int32)
    old_row = @rows[y]

    # Split the line in two
    @rows[y], new_row = old_row[0...x], old_row[x..-1]

    # Append to the new array
    @rows.insert y + 1, new_row
  end

  def duplicate_line(y : Int32)
    @rows.insert y + 1, @rows[y].dup
  end
end
