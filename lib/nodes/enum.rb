module Doxyparser

	class Enum < Member

		def values
			ret=[]
			xpath("enumvalue/name").each { |v| ret << v.child.content }
			ret
		end

		private

		def find_name
			super.gsub(/@\d*/) {
				num = parent.new_unnamed
				'_Enum' +  (num == 1 ? '' : num.to_s)
			}
		end
	end
end