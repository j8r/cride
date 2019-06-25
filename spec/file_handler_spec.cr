require "spec"
require "../src/file_handler"

SAMPLE_DATA = <<-DATA
this
 is\n
sample data\n
DATA

SAMPLE_FILE_PATH = File.tempname(suffix: "file_sample_test")

describe Cride::FileHandler do
  describe "parses a file sample" do
    File.write SAMPLE_FILE_PATH, SAMPLE_DATA
    file = Cride::FileHandler.read SAMPLE_FILE_PATH

    it "checks rows size" do
      file.rows.size.should eq SAMPLE_DATA.lines.size + 1
    end

    it "checks file name" do
      file.name.should eq SAMPLE_FILE_PATH
    end

    it "should be saved" do
      file.saved?.should be_true
    end

    it "to_s againt the original sample data" do
      file.to_s.should eq SAMPLE_DATA
    end

    it "writes to the disk" do
      file.write
      File.read(SAMPLE_FILE_PATH).should eq SAMPLE_DATA
    end
  ensure
    File.delete SAMPLE_FILE_PATH
  end

  it "parses emtpy data" do
    empty_file = Cride::FileHandler.new
    empty_file.rows.should eq [""]
    empty_file.name.should be_nil
    empty_file.saved?.should be_false
    empty_file.to_s.should eq ""
  end

  it "parses from io" do
    from_io = Cride::FileHandler.new IO::Memory.new(SAMPLE_DATA)
    from_io.rows.size.should eq SAMPLE_DATA.lines.size + 1
    from_io.name.should be_nil
    from_io.saved?.should be_false
  end

  it "parses a sample data string" do
    file_data = Cride::FileHandler.new SAMPLE_DATA
    file_data.rows.size.should eq SAMPLE_DATA.lines.size + 1
    file_data.name.should be_nil
    file_data.saved?.should be_false
  end

  it "parses an empty line" do
    data = "\n"
    temp = Cride::FileHandler.new(data: data)
    temp.rows.should eq ["", ""]
    temp.to_s.should eq data
  end
end
