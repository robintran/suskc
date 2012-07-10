class User < ParseUser
  validates_presence_of :email
  validates_presence_of :username

  fields :name
  fields :email
  
  attr_accessor :password_confirmation
  validate :check_password, on: :save
  
  def check_password
    errors.add(:password, "and password confirmation not match") if(self.password != self.password_confirmation)
  end
  
end
