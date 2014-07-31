module PlayerHelper
	def short_name(name)
		if name.size > 9
			name.gsub!(/[aeiou]/, '')
		else
			name
		end
	end
end