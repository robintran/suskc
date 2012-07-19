class User < ParseUser
  fields :role, :confirm_code
  
  def admin?
    return self.role=='admin'
  end
end
