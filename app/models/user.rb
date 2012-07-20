class User < ParseUser
  fields :role, :confirm_code
  
  def admin?
    return self.role=='admin'
  end
  
  def confirmed?
    return self.confirm_code=='confirmed'
  end
  
  def locations
    Location.where(user_id: self.id)
  end
  
end
