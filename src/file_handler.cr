class Cride::FileHandler
  property rows : Array(String)
  property saved : Bool
  property name : String
  getter add : Add
  getter delete : Delete

  def initialize(data = "", @name = "", @saved = false)
    @rows = data.lines
    @rows << ""

    @add = Add.new @rows, pointerof(@saved)
    @delete = Delete.new @rows, pointerof(@saved)
  end

  def initialize(file : File, @saved = true)
    @name = file.path
    @rows = File.read_lines @name
    @rows << ""

    @add = Add.new @rows, pointerof(@saved)
    @delete = Delete.new @rows, pointerof(@saved)
  end

  def to_s : String
    @rows.join '\n'
  end

  # Write the editor's data to a file
  def write
    if !@name.empty?
      File.write @name, to_s
      @saved = true
    end
  end
end

require "./file_handler/*"
