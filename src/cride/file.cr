class Cride::FileHandler
  property rows = Array(Array(Char)).new
  property saved = false
  property name = ""
  getter add : Add
  getter delete : Delete

  def initialize(@name = "")
    STDIN.read_timeout = 0
    stdin = STDIN.gets_to_end
    parse stdin
  rescue ex : IO::Timeout
    if File.exists? @name
      abort @name + "can't be read because it is a directory" if !File.file? @name
      parse File.read @name
      @saved = true
    end
  ensure
    @rows << Array(Char).new if @rows.empty?
    @add = Add.new @rows, @saved
    @delete = Delete.new @rows, @saved
  end

  def parse(data)
    array = Array(Char).new
    data.each_char do |char|
      if char == '\n'
        @rows << array
        array = Array(Char).new
      else
        array << char
      end
    end

    @rows << if array.empty?
      # line has a new empty line - create one
      Array(Char).new
    else
      # append the remaining characters
      array
    end
  end

  # Write the editor's data to a file
  def write
    if !@name.empty?
      data = String.build do |str|
        @rows.each do |line|
          str << '\n'
          line.each { |char| str << char }
        end
        # Remove the first \n
      end.lchop
      File.write @name, data
      @saved = true
    end
  end
end
