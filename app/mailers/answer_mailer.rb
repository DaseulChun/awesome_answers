class AnswerMailer < ApplicationMailer
  default from: 'notifications@awesomeanswers.com'

  # To generate a mailer do:
  # rails g mailer <name-of-mailer>

  # To read more about mailers: https://guides.rubyonrails.org/action_mailer_basics.html

  # In a Mailer, the public methods are used to create and send mail.
  # They're similar to actions in a controller.

  # To deliver 
  def hello_world
    mail(
      to: "nandaseul@gmail.com",
      from: "info@awesome-answers.io",
      cc: "test@awesome.com",
      bcc: "someone.else@example.com",
      subject: "Hello, World"
    )
  end

  def new_answer(answer)
    # Any instance variable se in a mailer will 
    # be available in its rendered templates.
    @answer = answer
    @question = answer.question
    @question_owner = @question.user

    mail(
      to: @question_owner.email,
      subject: "#{answer.user.first_name} answered your question"
    )
  end
end
