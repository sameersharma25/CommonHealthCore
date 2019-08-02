module ReferralsHelper

  def self.security_keys_for_referrals(values)
  	security_keys = []
	PiiTable.each do |key, value|
	  truthy = []
	      value.each do |x|
	            p "CHECK", x
	            obj2.each do |k,v|
	                p v
	                if x == k && v != "" && v != nil
	                #if x == v 
	                  truthy.push(true)
	                end  
	            end 
	            if truthy.length == value.length   
	              security_keys.push(key)  
	            end 
	      end 
	      p security_keys
	end 
    ##
    SadTable.each do |key, value|
	  truthy = []
	      value.each do |x|
	            p "CHECK", x
	            obj2.each do |k,v|
	                p v
	                if x == k && v != "" && v != nil
	                #if x == v 
	                  truthy.push(true)
	                end  
	            end 
	            if truthy.length == value.length   
	              security_keys.push(key)  
	            end 
	      end 
	      p security_keys
	end 
	##
	PhiTable.each do |key, value|
		  truthy = []
		      value.each do |x|
		            p "CHECK", x
		            obj2.each do |k,v|
		                p v
		                if x == k && v != "" && v != nil
		                #if x == v 
		                  truthy.push(true)
		                end  
		            end 
		            if truthy.length == value.length   
		              security_keys.push(key)  
		            end 
		      end 
		      p security_keys
		end 
		return security_keys
end
