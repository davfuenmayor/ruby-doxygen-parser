require 'rubygems'
require 'rspec'
require 'doxyparser'

describe "Doxyparser" do

  it "should create correctly namespaces, groups, classes and structs" do

    xmldir= File.expand_path(__dir__+"/xml")
    clazz=Doxyparser::parse_class("MyNamespace::MyClass", xmldir)
    group=Doxyparser::parse_group("Animation", xmldir)
    namespace=Doxyparser::parse_namespace("MyNamespace", xmldir)
    struct=Doxyparser::parse_struct("MyNamespace::MyClass::InnerStruct", xmldir)
    hfile=Doxyparser::parse_header_file("test.h", xmldir)

    clazz.name.should_not be_empty
    group.name.should_not be_empty
    namespace.name.should_not be_empty
    struct.name.should_not be_empty
    hfile.name.should_not be_empty

    # To force lazy parsing
    puts clazz.file
    puts struct.file
    puts hfile.path

  end


end