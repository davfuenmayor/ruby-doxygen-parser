require 'rubygems'
require 'rspec'
require 'doxyparser'

require_relative 'custom_spec_helper'

describe "Doxyparser::Type" do

	before(:all) do
		@class=Doxyparser::parse_class('MyNamespace::MyClass', xml_dir)
	end

	it "should create consistently simple types" do
		typedef = @class.typedefs(:public, ['MapShortVectorInt'])[0]
		type = typedef.type
		type.name.should eql 'std::map< unsigned short, std::vector< int * > >'
		type.should be_template
		
		typedef = @class.typedefs(:public, ['VectorMapShortVectorInt'])[0]
		type = typedef.type
		type.name.should eql 'std::vector< MapShortVectorInt & >'
		type.should be_template
	end
	
	it "should create consistently complex types" do
		typedef = @class.typedefs(:private, ['privateTypedef'])[0]
		type = typedef.type
		type.name.should eql 'std::map< MyMostInnerClass *, TemplateClass< const OuterStruct &,::noNsClass, 8 > >'
		type.should be_template
		type.nested_local_types.map{|t| t.name}.should eql ['MyMostInnerClass', 'TemplateClass', 'OuterStruct', 'noNsClass']
		type.nested_typenames.should eql ['std::map', 'MyMostInnerClass' , 'TemplateClass', 'OuterStruct', '::noNsClass']
	end

end