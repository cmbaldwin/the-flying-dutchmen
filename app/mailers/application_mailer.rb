class ApplicationMailer < ActionMailer::Base
  default from: ENV["FROM_ADDRESS"]
  layout 'mailer'

end

# For simple tests.
# ActionMailer::Base.mail(
#   from: "test@example.co", 
#   to: "valid.recipient@domain.com", 
#   subject: "Test", 
#   body: "Test"
# ).deliver_now
# 
# Read more here: http://guides.rubyonrails.org/action_mailer_basics.html