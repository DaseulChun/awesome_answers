ActionMailer::Base.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  authentication:       'plain',
  enable_starttls_auto: true,
  user_name:            ENV["EMAIL_USERNAME"],
  password:             ENV["EMAIL_PASSWORD"]
}