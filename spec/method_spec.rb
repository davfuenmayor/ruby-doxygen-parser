require 'rubygems'
require 'rspec'
require 'doxyparser'

require_relative 'custom_spec_helper'

describe "Doxyparser::Method" do
	
	before(:all) do
			@class=Doxyparser::parse_class("AccessorsClass", xml_dir)
		end

		it "should create consistently methods" do
			method = @class.methods(:private, nil, ['isBoolPropis'])
			method.size.should eql 1
			method = method[0]
			method.type.name.should eql 'bool'
			method.args.should eql '()'
			method.location.should match /test2.h:\d+$/			
			method.file.basename.should eql 'test2.h'
			method.params.should be_empty
			method.static.should be_nil
			method.definition.should eql 'bool AccessorsClass::isBoolPropis'
		end
		
		it "should create standard getters and setters" do
			getter = @class.methods(:private, nil, ['getPropget'])[0]
			getter.getter_for.should eql 'propget'
			getter.setter_for.should be_nil
			setter = @class.methods(:private, nil, ['setPropset'])[0]
			setter.setter_for.should eql 'propset'
			setter.getter_for.should be_nil
			setter.static.should be_nil
			
			getter = @class.methods(:private, nil, ['isBoolPropis'])[0]
			getter.getter_for.should eql 'boolPropis'
			getter.setter_for.should be_nil
		end
		
		it "should create non standard getters and setters" do
			getter = @class.methods(:private, nil, ['get_Prop2get_'])[0]
			getter.getter_for.should eql 'prop2get_'
			getter.setter_for.should be_nil
			setter = @class.methods(:private, nil, ['set_Prop2set_2'])[0]
			setter.setter_for.should eql 'prop2set_2'
			setter.getter_for.should be_nil
			setter.static.should be_nil
		end
		
		it "should create standard Uppercase getters and setters" do
			getter = @class.methods(:private, nil, ['Get3DProp3'])[0]
			getter.getter_for.should eql '_3DProp3'
			getter.setter_for.should be_nil
			setter = @class.methods(:private, nil, ['Set3DProp3'])[0]
			setter.setter_for.should eql '_3DProp3'
			setter.getter_for.should be_nil
			setter.static.should be_nil
		end
		
		it "should ignore malformed getters and setters" do
			getter = @class.methods(:private, nil, ['getNotAProp'])[0]
			getter.getter_for.should be_nil
			getter.setter_for.should be_nil
			setter = @class.methods(:private, nil, ['setNotAProp'])[0]
			setter.setter_for.should be_nil
			setter.getter_for.should be_nil
		end
		
		it "should ignore malformed getters and setters Pt. 2" do
			getter = @class.methods(:private, nil, ['isNotAProp'])[0]
			getter.getter_for.should be_nil
			getter.setter_for.should be_nil
			setter = @class.methods(:private, nil, ['isAlsoNotAProp'])[0]
			setter.setter_for.should be_nil
			setter.getter_for.should be_nil
		end
		
		it "should create static getters and setters" do			
			static_getter = @class.methods(:private, true, ['getStaticProp'])[0]
			static_getter.getter_for.should eql 'staticProp'
			static_getter.setter_for.should be_nil
			static_setter = @class.methods(:private, :x, ['setStaticProp'])[0]
			static_setter.setter_for.should eql 'staticProp'
			static_setter.getter_for.should be_nil
		end
end