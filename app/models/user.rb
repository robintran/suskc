class User < ParseUser
  fields :role, :confirm_code, :plan, :customer_id
  
  def admin?
    return self.role=='admin'
  end
  
  def confirmed?
    return self.confirm_code=='confirmed'
  end
  
  def is_member?
    return self.plan=='Member'
  end
  
  def locations
    Location.where(user_id: self.id)
  end
  
end
