class User < ParseUser
  validates_presence_of :username

  fields :name

  fields :email
end
