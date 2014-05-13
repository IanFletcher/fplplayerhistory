module FlashHelper
	def flash_display
	  response = ""
	  flash.each do |name, msg|
	    response = response + 
	    	new_message(name, msg)
	  end
	  response
	end
	def new_message(name, msg)
		if name == :notice
	    content_tag(:div, msg, :id => "flash_#{name}", :class => "notice")
		else
	    content_tag(:div, msg, :id => "flash_#{name}", :class => "alert")
		end
	end					
end