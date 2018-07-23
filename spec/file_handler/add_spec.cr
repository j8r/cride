require "../spec_helper"

describe Cride::FileHandler::Add do
  saved = false

  it "modifies a char" do
    rows = ["some", "sample", "text"]
    file_add = Cride::FileHandler::Add.new rows, pointerof(saved)
    file_add.set_char 3, 1, 'A'
    rows.should eq ["some", "samAle", "text"]
  end

  it "adds a char" do
    rows = ["some", "sample", "text"]
    file_add = Cride::FileHandler::Add.new rows, pointerof(saved)
    file_add.char 3, 1, 'A'
    rows.should eq ["some", "samAple", "text"]
  end

  it "adds a line" do
    rows = ["some", "sample", "text"]
    file_add = Cride::FileHandler::Add.new rows, pointerof(saved)
    file_add.line 3, 1
    rows.should eq ["some", "sam", "ple", "text"]
  end

  it "duplicates a line" do
    rows = ["some", "dup", "text"]
    file_add = Cride::FileHandler::Add.new rows, pointerof(saved)
    file_add.duplicate_line 1
    rows.should eq ["some", "dup", "dup", "text"]
  end
end
