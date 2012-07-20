class ConfirmMailer < ActionMailer::Base
  default from: "admin@suskc.com"

  def email_confirm(email, confirm_link)
    @email = email
    @confirm_link = confirm_link   
    mail(:to => email, :subject => "Confirm email at Startup Shop KC")
  end
  
end
