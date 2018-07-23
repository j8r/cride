class Cride::FileHandler
  property rows
  property saved
  property name
  getter add : Add
  getter delete : Delete

  def initialize(data = "", @name = "", @saved = false)
    @rows = data.lines
    create_empty_row

    @add = Add.new @rows, pointerof(@saved)
    @delete = Delete.new @rows, pointerof(@saved)
  end

  def initialize(file : File, @saved = true)
    @name = file.path
    @rows = File.read_lines @name
    create_empty_row

    @add = Add.new @rows, pointerof(@saved)
    @delete = Delete.new @rows, pointerof(@saved)
  end

  private def create_empty_row
    if @rows.empty?
      @rows << ""
    elsif !@rows.last.empty?
      @rows << ""
    end
  end

  def to_s : String
    String.build do |str|
      @rows.join '\n', str
      str << '\n'
    end
  end

  # Write the editor's data to a file
  def write
    if !@name.empty?
      File.write @name, to_s
      @saved = true
    end
  end
end
