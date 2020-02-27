Aws.config[:credentials] = Aws::Credentials.new('AKIAJVYAUKVIR5AFM6RA', 'Zao11UQH8UMsgPiO9q2zwxBThpCbL2ImHXArfM1g')
Aws.config[:region] = 'us-west-2'
if Rails.env.test?  #overriding value for test env.
  Aws.config[:credentials] = Aws::Credentials.new('', '')
  Aws.config[:region] = 'us-west-2'
end