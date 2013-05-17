require 'rubygems'
require 'rspec'
require 'doxyparser'

require_relative 'custom_spec_helper'

describe "Doxyparser::HFile" do

	before(:all) do
		@file = Doxyparser::parse_header_file('test1.h', xml_dir)
	end
	
	it "should be created correctly" do
			@file.name.should eql 'test1.h'
			@file.basename.should eql 'test1.h'
			@file.xml_path.should eql xml_dir+'/test1_8h.xml'
	end

	it "should correctly generate includes and included_by listing" do
		expected_included= ['stdlib.h', 'vector', 'list', 'map', 'iostream', 'test3.h']
		expected_including= ['test3.h', 'test2.h', 'test4.h']
		@file.list_included.should eql expected_included
		@file.list_including.should eql ['test3.h', 'test2.h', 'test4.h']
	end

	it "should correctly generate includes and included_by files" do
		expected_included= ['test3.h']
		expected_including= ['test3.h', 'test2.h', 'test4.h']
		@file.files_included.map{|f| f.basename}.should eql expected_included
		@file.files_including.map{|f| f.basename}.should eql expected_including
	end

	it "should create the right classes and structs" do
		expected_classes=['noNsClass', "MyNamespace::MyInnerNamespace::MyMostInnerNamespace::MyClass", "MyNamespace::TemplateClass", "MyNamespace::MyClass", "MyNamespace::MyClass::InnerClass"]
		expected_structs=["noNsStruct", "MyNamespace::OuterStruct", "MyNamespace::MyClass::InnerStruct"]

		file_classes = @file.classes
		file_structs = @file.structs
		file_classes.size.should eql expected_classes.size
		file_structs.size.should eql expected_structs.size

		file_all = file_classes + file_structs
		file_all.uniq.should eql file_all# No element should be repeated

		file_classes.each{|c|
			c.class.should eql Doxyparser::Class
			expected_classes.should include c.name
			c.parent.should be_nil
			c.xml_path.should be_start_with xml_dir
		}
		file_structs.each{|c|
			c.class.should eql Doxyparser::Struct
			expected_structs.should include c.name
			c.parent.should be_nil
			c.xml_path.should be_start_with xml_dir
		}
	end
	
	it "should create the right namespaces" do
		expected_namespaces=['MyNamespace', "MyNamespace::MyInnerNamespace", "MyNamespace::MyInnerNamespace::MyMostInnerNamespace", "std"]
		file_namespaces = @file.namespaces
		file_namespaces.size.should eql expected_namespaces.size

		file_namespaces.uniq.should eql file_namespaces # No element should be repeated

		file_namespaces.each{|c|
			c.class.should eql Doxyparser::Namespace
			expected_namespaces.should include c.name
			c.parent.should be_nil
			c.xml_path.should be_start_with xml_dir
		}
	end
	
	it "should create functions" do
		functions = @file.functions
		functions.size.should eql 1
		functions[0].name.should eql 'test1.h::noNsFunction'
		functions[0].basename.should eql 'noNsFunction'
	end
	
	it "should create variables" do
		variables = @file.variables
		variables.size.should eql 1
		variables[0].name.should eql 'test1.h::noNsVariable'
		variables[0].basename.should eql 'noNsVariable'
	end
	
	it "should create enums" do
		enums = @file.enums
		enums.size.should eql 1
		enums[0].name.should eql 'test1.h::noNsEnum'
		enums[0].basename.should eql 'noNsEnum'
	end
	
	it "should create typedefs" do
		typedefs = @file.typedefs
		typedefs.size.should eql 1
		typedefs[0].name.should eql 'test1.h::noNsTypedef'
		typedefs[0].basename.should eql 'noNsTypedef'
	end
end