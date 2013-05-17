require 'rubygems'
require 'rspec'
require 'doxyparser'

require_relative 'custom_spec_helper'

describe "Doxyparser" do

  it "should not burn with api calls" do

    clazz=Doxyparser::parse_class("MyNamespace::MyClass", xml_dir)
    namespace=Doxyparser::parse_namespace("MyNamespace", xml_dir)
    struct=Doxyparser::parse_struct("MyNamespace::MyClass::InnerStruct", xml_dir)
    hfile=Doxyparser::parse_header_file("test.h", xml_dir)

    clazz.name.should_not be_empty
    namespace.name.should_not be_empty
    struct.name.should_not be_empty
    hfile.name.should_not be_empty
    hfile.basename.should_not be_empty

  end


end