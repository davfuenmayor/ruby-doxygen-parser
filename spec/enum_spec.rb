require 'rubygems'
require 'rspec'
require 'doxyparser'

require_relative 'custom_spec_helper'

describe "Doxyparser::Enum" do

		it "should create consistently enums" do

			clazz = Doxyparser::parse_class('MyNamespace::MyClass', xml_dir)
			enum = clazz.innerenums(:public, ['_Enum'])
			enum.size.should eql 1
			enum[0].values.should eql ['value1', 'value2','value3']
			enum = clazz.innerenums(:public, ['InnerEnum'])
			enum[0].values.should eql ['A', 'B','C']	
		end
end