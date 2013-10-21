require 'rubygems'
require 'rspec'
require 'doxyparser'

require_relative 'custom_spec_helper'

describe "Doxyparser::Enum" do

		it "should create consistently enums" do
			clazz = Doxyparser::parse_class('MyNamespace::MyClass', xml_dir)
			enum = clazz.enums(:public, ["MyClass_Enum"])
			enum.size.should eql 1
			enum[0].values.map{ |v| v.basename}.should eql ['value1', 'value2','value3']
			enum = clazz.enums(:public, ['InnerEnum'])
			enum[0].values.map{ |v| v.basename}.should eql ['A', 'B','C']
			enum[0].values.map{ |v| v.initializer}.should eql ['23', 'A + 1','A + B']	
		end
end