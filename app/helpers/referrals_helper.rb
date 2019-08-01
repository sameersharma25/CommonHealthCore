module ReferralsHelper

  def self.security_keys_for_referrals(values)
    security_keys_array = []
    PhiTable.each do |k,v| 
        allTrue = []
          values.each do |o,p|
              if v.include?(values[o]) && p != nil && p != ''
                  allTrue.push(true)
              else
                  allTrue.push(false)
              end 
          end 

          if allTrue.include?(false)
              #break
          else
              #Patient.security_keys.push(k)
              security_keys_array.push(k)
          end 
        
    end 
    ##
    PiiTable.each do |k,v| 
        allTrue = []
          values.each do |o,p|
              if v.include?(values[o]) && p != nil && p != ''
                  allTrue.push(true)
              else
                  allTrue.push(false)
              end 
          end 

          if allTrue.include?(false)
              #break
          else
              #Patient.security_keys.push(k)
              security_keys_array.push(k)
          end 
        
    end
    ##
    SadTable.each do |k,v| 
        allTrue = []
          values.each do |o,p|
              if v.include?(values[o]) && p != nil && p != ''
                  allTrue.push(true)
              else
                  allTrue.push(false)
              end 
          end 

          if allTrue.include?(false)
              #break
          else
              #Patient.security_keys.push(k)
              security_keys_array.push(k)
          end 
        
    end
    	return security_keys_array 
  end
end
