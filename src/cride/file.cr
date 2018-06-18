class Cride::FileHandler
  property rows = Array(Array(Char)).new
  property saved = false
  property name = ""
  getter add : Add
  getter delete : Delete

  def initialize(@name = "")
    STDIN.read_timeout = 0
    parse STDIN.gets_to_end
  rescue ex : IO::Timeout
    if File.exists? @name
      abort @name + "can't be read because it is a directory" if !File.file? @name
      parse File.open @name
      @saved = true
    end
  ensure
    @rows << Array(Char).new if @rows.empty?
    @add = Add.new @rows, pointerof(@saved)
    @delete = Delete.new @rows, pointerof(@saved)
  end

  def parse(data)
    data.each_line do |line|
      @rows << line.chars
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
