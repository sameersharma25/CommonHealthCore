
obj1 = { pii_table: ["two","one", "three"], phi_table: ['four','five','six'], sad_table: ['one','nine','two']}
obj2 = {one: 'one', three: 'three', four: 'four', five: 'five', six: 'six', two: 'two'}





patient_array = []
obj2.each do |k,v|
  if v != '' && v != nil
    patient_array.push(v)
  end 
end

obj1.each do |k,v|
  p 'security key set', v
  p 'patient set', patient_array 
  if (v - patient_array) == []
    p 'its a match'
  else 
    p patient_array, '!=', v
  end 
  p '*** BREAK ***'
end 

#security_keys = []
#obj1.each do |key, value|
#  truthy = []
#      value.each do |x|
#            p "CHECK", x
#            obj2.each do |k,v|
#                p v
#                #if x == k && v != "" && v != nil
#                if x == v 
#                  truthy.push(true)
#                end  
#            end 
#            if truthy.length == value.length   
#              security_keys.push(key)  
#            end 
#      end 
#      p security_keys
#end 