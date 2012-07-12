class User < ParseUser
  validates :email, presence: true

  fields :name
  fields :email
  
end
