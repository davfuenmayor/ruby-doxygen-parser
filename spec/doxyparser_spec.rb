require 'rubygems'
require 'rspec'
require_relative '../lib/doxyparser'

require_relative 'custom_spec_helper'

describe "Doxyparser" do

	it "should not burn with api calls" do
		clazz=Doxyparser::parse_class("MyNamespace::MyClass", xml_dir)
		namespace=Doxyparser::parse_namespace("MyNamespace", xml_dir)
		struct=Doxyparser::parse_struct("MyNamespace::MyClass::InnerStruct", xml_dir)
		hfile=Doxyparser::parse_file("test.h", xml_dir)
		output = Doxyparser::gen_xml_docs(home_dir + '/spec/headers', home_dir + '/spec/test_gen', true, ['usr/local/include', 'usr/gato'])
		output.should_not be_empty
		clazz.name.should_not be_empty
		namespace.name.should_not be_empty
		struct.name.should_not be_empty
		hfile.name.should_not be_empty
		hfile.basename.should_not be_empty
	end
end