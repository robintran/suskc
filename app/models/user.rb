class User < ParseUser
  fields :role, :confirm_code, :customer_id
  
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
