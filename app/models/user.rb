class User < ActiveRecord::Base
  # fields :role, :confirm_code, :customer_id
  attr_accessible :username, :password, :password_confirmation, :role, :confirm_code, :customer_id
  has_secure_password
  

  
  def admin?
    return self.role=='admin'
  end
  
  def confirmed?
    return self.confirm_code=='confirmed'
  end
  
  def events
    Event.where(user_id: self.id)
  end
  
  def locations
    Location.where(user_id: self.id)
  end  

end
