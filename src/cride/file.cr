class Cride::FileHandler
  property rows = Array(String).new
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
    @rows = File.read_lines file.path
    @name = file.path
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

  # Write the editor's data to a file
  def write
    if !@name.empty?
      File.write @name, @rows.join('\n')
      @saved = true
    end
  end
end
