struct Cride::Editor
  getter position = Position.new
  getter file : Cride::FileHandler
  getter add : Add
  getter delete : Delete
  getter move : Move
  getter size : Size

  def initialize(@file, @size)
    @move = Cride::Editor::Move.new @file, @position, @size
    @add = Cride::Editor::Add.new @file, @position, @move
    @delete = Cride::Editor::Delete.new @file, @position, @move
  end
end

class Cride::Size
  property width : Int32, height : Int32

  def initialize(@width = 0, @height = 0)
  end
end
