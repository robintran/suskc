if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.gmail.com',
    :port           =>  587,
    :domain         => 'baci.lindsaar.net',
    :authentication => 'plain',
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :enable_starttls_auto => true 
  }
else
  ActionMailer::Base.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'baci.lindsaar.net',
      :user_name            => 'mytest1221@gmail.com',
      :password             => '11qqaazz',
      :authentication       => 'plain',
      :enable_starttls_auto => true 
    } 
end  
ActionMailer::Base.delivery_method = :smtp
