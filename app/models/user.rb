class User < ActiveRecord::Base
   has_one :pets_account
   actable
   validates_presence_of :email
   validates_presence_of :first_name
   validates_presence_of :last_name
   validates_format_of   :phone, 
    with: /\A\d{3}-\d{3}-\d{4}|\A\d[0-9]\z/,
    
      message: 'should be in form of 123-345-7989',
    allow_blank: true
end
