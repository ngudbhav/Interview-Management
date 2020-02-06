class InterviewMailer < ApplicationMailer
    default from: 'ngudbhavtest@outlook.com'

    def reminder_email(to)
        puts "Delivering Mail now"
        mail(to: to, subject: 'Reminder for Interview', body: 'Sending mail')
    end
end
