struct Cride::Editor
  getter position = Position.new
  getter file : Cride::FileHandler
  getter size : Cride::Size
  getter add : Cride::Editor::Add
  getter delete : Cride::Editor::Delete
  getter move : Cride::Editor::Move

  def initialize(file, @size)
    @file = Cride::FileHandler.new file
    @move = Cride::Editor::Move.new @file, @position, @size
    @add = Cride::Editor::Add.new @file, @position, @move
    @delete = Cride::Editor::Delete.new @file, @position, @move
  end
end

class Cride::Position
  property cursor_x : Int32, cursor_y : Int32, page_x : Int32, page_y : Int32

  def initialize(@cursor_x = 0, @cursor_y = 0, @page_x = 0, @page_y = 0)
  end

  def absolute_x : Int32
    @cursor_x + @page_x
  end

  def absolute_y : Int32
    @cursor_y + @page_y
  end
end

class Cride::Size
  property width : Int32, height : Int32

  def initialize(@width = 0, @height = 0)
  end
end
