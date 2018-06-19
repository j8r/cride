class Cride::FileHandler
  property rows = Array(Array(Char)).new
  property saved
  property name
  getter add : Add
  getter delete : Delete

  def initialize(data = "", @name = "", @saved = false)
    data.each_line do |line|
      @rows << line.chars
    end
    if @rows.empty?
      @rows << Array(Char).new
    elsif !@rows.last.empty?
      @rows << Array(Char).new
    end

    @add = Add.new @rows, pointerof(@saved)
    @delete = Delete.new @rows, pointerof(@saved)
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
