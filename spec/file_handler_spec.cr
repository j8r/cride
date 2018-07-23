require "./spec_helper"

describe Cride::FileHandler do
  sample_data = <<-DATA
  this
   is\n
  sample data\n
  DATA

  sample_file = "./file_sample_test"
  File.write sample_file, sample_data
  file = Cride::FileHandler.new

  it "parses emtpy data" do
    file.rows.should eq [""]
    file.name.should eq ""
    file.saved.should be_false
    file.to_s.should eq "\n"
  end

  it "parses two empty lines" do
    data = "\n"
    temp = Cride::FileHandler.new(data: data)
    temp.rows.should eq [""]
    temp.to_s.should eq data
  end

  it "parses a sample file" do
    file = Cride::FileHandler.new File.new(sample_file)
  end

  it "checks rows size" do
    file.rows.size.should eq sample_data.lines.size + 1
  end

  it "checks file name" do
    file.name.should eq sample_file
  end

  it "should be saved" do
    file.saved.should be_true
  end

  it "parses a sample data" do
    file_data = Cride::FileHandler.new sample_data
    file_data.rows.should eq file.rows
    file_data.name.should eq ""
    file_data.saved.should be_false
  end

  it "to_s againt the original sample data" do
    file.to_s.should eq sample_data + '\n'
  end

  it "writes to the disk" do
    file.write
    File.read(sample_file).should eq sample_data + '\n'
  end

  File.delete sample_file
end
