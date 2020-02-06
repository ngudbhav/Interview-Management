class ReminderMail
    include Sidekiq::Worker 
    def perform(id, to, start)
        puts "Sending mail now"
        now = Time.now
        diff = now - Time.utc(start)
        if diff<1800
            InterviewMailer.remind_mail(to).deliever_now
        end
    end
end