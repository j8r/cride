class Cride::FileHandler
  property rows = Array(String).new
  property saved
  property name
  getter add : Add
  getter delete : Delete

  def initialize(data : String | File = "", @name = "", @saved = false)
    @rows = File.read_lines data.path if data.is_a? File
    if @rows.empty?
      @rows << String.new
    elsif !@rows.last.empty?
      @rows << String.new
    end

    @add = Add.new @rows, pointerof(@saved)
    @delete = Delete.new @rows, pointerof(@saved)
  end

  # Write the editor's data to a file
  def write
    if !@name.empty?
      data = String.build do |str|
        @rows.each do |line|
          str << line << '\n'
        end
        # Remove the first \n
      end
      File.write @name, data
      @saved = true
    end
  end
end
