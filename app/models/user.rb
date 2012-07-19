class User < ParseUser
  fields :role
  
  def admin?
    return self.role=='admin'
  end
end
