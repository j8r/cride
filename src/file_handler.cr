class Cride::FileHandler
  property rows : Array(String)
  # Name or file path in disk.
  property name : String?
  getter add : Add
  getter delete : Delete

  @previous_row_hash : UInt64

  # The data is saved on disk.
  def saved? : Bool
    @previous_row_hash == @rows.hash
  end

  # Reads from a `String`.
  def self.new(data : String = "", name : String? = nil, saved : Bool = false)
    rows = data.lines
    rows << ""
    new name, rows, saved
  end

  # Read from an `IO`.
  def self.new(io : IO, name : String? = nil, saved : Bool = false)
    rows = Array(String).new
    io.each_line do |line|
      rows << line
    end
    rows << ""
    new name, rows, saved
  end

  # Reads from a file.
  def self.read(file_name : String?, saved : Bool = true)
    rows = File.read_lines file_name
    rows << ""
    new file_name, rows, saved
  end

  def initialize(@name : String?, @rows : Array(String), saved : Bool = false)
    @previous_row_hash = saved ? rows.hash : 0_u64
    @add = Add.new @rows
    @delete = Delete.new @rows
  end

  def to_s : String
    @rows.join '\n'
  end

  # Write the editor's data to a file
  def write
    if file_path = @name
      File.write file_path, to_s
      @previous_row_hash = rows.hash
    end
  end
end

require "./file_handler/*"
