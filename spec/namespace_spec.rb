require 'rubygems'
require 'rspec'
require_relative '../lib/doxyparser'

require_relative 'custom_spec_helper'

describe "Doxyparser::Namespace" do

	context "Basic" do

		before(:all) do
			@namespace=Doxyparser::parse_namespace("Ogre", xml_dir)
		end

		it "should be created consistently from name and directory" do
			namespace_data = {name: "Ogre", basename:  "Ogre", node: nil, parent: nil, path: xml_dir+'/namespaceOgre.xml'}
			@namespace.class.should eql Doxyparser::Namespace
			@namespace.name.should eql namespace_data[:name]
			@namespace.basename.should eql namespace_data[:basename]
			@namespace.xml_path.should eql namespace_data[:path]
			@namespace.file.should be_nil
		end

		it "should create the right typedefs according to a specified list" do
			expected_typedefs=['AnimableValuePtr', 'AnimationStateMap', 'ConstAnimationStateIterator']
			ns_typedefs = @namespace.typedefs(expected_typedefs)
			ns_typedefs.size.should eql expected_typedefs.size
			ns_typedefs.uniq.should eql ns_typedefs
			ns_typedefs.each{|t|
				t.class.should eql Doxyparser::Typedef # Class must be correct
				t.parent.should eql @namespace # Parent must be correct
				expected_typedefs.should include t.basename
				t.name.should be_start_with("#{@namespace.name}::")
			}
		end

		it "should create the right functions according to a specified list" do
			expected_functions=['operator>', 'operator<=', 'intersect', 'advanceRawPointer', 'any_cast']
			ns_functions = @namespace.functions(expected_functions)
			# Should return more elements than the list (because any_cast() is overloaded)
			ns_functions.size.should be.>expected_functions.size
			ns_functions.uniq.should eql ns_functions# Function overrides "==" and therefore
			# no element should be repeated
			ns_functions.each{|f|
				f.class.should eql Doxyparser::Function# Class must be correct
				f.parent.should eql @namespace# Parent must be correct
				expected_functions.should include f.basename# Each function must be included in
				# the given list
				f.name.should be_start_with("#{@namespace.name}::")
			}
		end

		it "should create the right enums according to a specified list" do
			expected_enums=['LayerBlendOperationEx', 'ShadowTechnique', 'GpuConstantType', 'MeshChunkID']
			ns_enums = @namespace.enums(expected_enums)
			ns_enums.size.should eql expected_enums.size# Should return same number of
			# elements as the list
			ns_enums.uniq.should eql ns_enums# No element should be repeated
			ns_enums.each{|e|
				e.class.should eql Doxyparser::Enum# Class must be correct
				e.parent.should eql @namespace# Parent must be correct
				expected_enums.should include e.basename# Each function must be included in the
				# given list
				e.name.should be_start_with("#{@namespace.name}::")
			}
		end

		it "should create the right variables according to a specified list" do
			expected_vars=['pi', 'SPOT_SHADOW_FADE_PNG', 'RENDER_QUEUE_COUNT']
			ns_vars = @namespace.variables(expected_vars)
			ns_vars.size.should eql expected_vars.size# Should return same number of elements
			# as the list
			ns_vars.uniq.should eql ns_vars# No element should be repeated
			ns_vars.each{ |v|
				v.class.should eql Doxyparser::Variable# Class must be correct
				v.parent.should eql @namespace# Parent must be correct
				expected_vars.should include v.basename# Each function must be included in the
				# given list
				v.name.should be_start_with("#{@namespace.name}::")
			}
		end

		it "should correctly create the right classes and structs according to a specified list" do

			expected_classes=['AnimationTrack', "Root", "RibbonTrail", "SceneManager"]
			expected_structs=["isPodLike", "ViewPoint", "RenderablePass"]

			ns_classes = @namespace.classes(expected_classes)
			ns_structs = @namespace.structs(expected_structs)
			ns_classes.size.should eql expected_classes.size
			ns_structs.size.should eql expected_structs.size#

			ns_all = ns_classes + ns_structs
			ns_all.uniq.should eql ns_all# No element should be repeated among classes and
			# structs

			ns_classes.each{|c|
				c.class.should eql Doxyparser::Class
				expected_classes.should include c.basename
			}
			ns_structs.each{|c|
				c.class.should eql Doxyparser::Struct
				expected_structs.should include c.basename
			}
			ns_all.each{|c|
				c.parent.should eql @namespace
				c.xml_path.should eql xml_dir+"/#{c.refid}.xml"
				c.name.should be_start_with("#{@namespace.name}::")
			}
		end

		it "should correctly create the right inner namespaces according to a specified list" do
			expected_inner_ns=['EmitterCommands', 'OverlayElementCommands']
			inner_ns = @namespace.innernamespaces(expected_inner_ns)
			inner_ns.size.should eql expected_inner_ns.size# Should return same name of
			# elements as expected...
			inner_ns.uniq.should eql inner_ns# ... and no element should be repeated

			inner_ns.each{|ns|
			# Class must be correct
				ns.class.should eql Doxyparser::Namespace

				# Class should have a correct parent
				ns.parent.should eql @namespace

				# XML File path must be correct
				ns.xml_path.should eql xml_dir+%Q{/#{ns.refid}.xml}

				# The classes must be included in the given filter
				expected_inner_ns.should include ns.basename
				ns.name.should be_start_with("#{@namespace.name}::")
			}
		end
	end
	context "Advanced" do
		
		before(:all) do
			@myNamespace=Doxyparser::parse_namespace("MyNamespace", xml_dir)
		end

		it "should correctly create nested inner-namespace hierarchies" do
			@myNamespace=Doxyparser::parse_namespace("MyNamespace", xml_dir)
			inner_ns = @myNamespace.innernamespaces
			inner_ns.size.should eql 1			
			myInnerNamespace = inner_ns[0]
			myInnerNamespace.parent.should eql @myNamespace
			myInnerNamespace.xml_path.should eql xml_dir+%Q{/#{myInnerNamespace.refid}.xml}
			myInnerNamespace.name.should eql "#{@myNamespace.name}::MyInnerNamespace"
			
			inner_ns = myInnerNamespace.innernamespaces
			inner_ns.size.should eql 1			
			myMostInnerNamespace = inner_ns[0]
			myMostInnerNamespace.parent.should eql myInnerNamespace
			myMostInnerNamespace.xml_path.should eql xml_dir+%Q{/#{myMostInnerNamespace.refid}.xml}
			myMostInnerNamespace.name.should eql "#{myInnerNamespace.name}::MyMostInnerNamespace"
			
			myClass = myMostInnerNamespace.classes[0]
			myEnum = myMostInnerNamespace.enums[0]
			
			myClass.name.should eql "#{myMostInnerNamespace.name}::MyClass"
			myEnum.name.should eql "#{myMostInnerNamespace.name}::MyEnum"		
			
		end
	end
end