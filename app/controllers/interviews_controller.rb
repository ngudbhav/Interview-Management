class InterviewsController < ApplicationController
    def index
        @interviews = Interview.order("created_at DESC")
        #render "interviews/index"
    end
    def show
        @interview = Interview.find(params[:id])
        @result = @interview.attributes.merge({"people" => @interview.people})
        # @participants = Participant.where(interview_id: params[:id])
        # @participants.each do |item|
        #     @person = Person.find(item.person_id)
        #     @email = @person.email
        #     @interview[:email] = @email
        # end
    end
    def edit
        @interview = Interview.find(params[:id])
        @result = @interview.attributes.merge({"people" => @interview.people})
    end
    def update
        count = 0;
        participant = params[:participants].split(',')
        if params[:end] < params[:start]
            return render json: {"error": "End time must be greater than start time"}
        end
        participant.each do |item|
            @person = Person.find_by_email(item)
            if @person.nil?
            else
                puts "Printing interviews of people"
                @diff = @person.attributes.merge({"interviews" => @person.interviews})
                @diff["interviews"].each do |item|
                    if (params[:start] < item.start && params[:end] < item.start) || (params[:start] > item.end && params[:end] > item.end)
                        puts "If condition"
                    else
                        puts "Else Condition"
                        print item.title
                        if item.id == params[:id].to_i
                            print "Current interview"
                        else
                            print item.id
                            print params[:id]
                            count = count+1
                        end
                    end
                end
            end
        end
        if count == 0
            @interview = Interview.find(params[:id])
            Interview.where(id: params[:id]).update_all(start: params[:start], end: params[:end], title: params[:title])
            @interview.people.clear
            InterviewMailer.reminder_email(params[:participants]).deliver_now
            participants = params[:participants].split(',')
            participants.each do |item|
                person = Person.where(email: item)
                id = 0
                if person.empty?
                    @person = Person.create(email: item)
                    id = @person[:id]
                    print id
                    @interviews.people << @person
                else
                    id = person.pluck(:id)
                    print id
                    @interview.people << person
                end
            end
            redirect_to "/interviews"
        else
            print count
            render json: {"error": "Time overlapping Detected. Records not added!"}
        end
    end
    def destroy
        @interview = Interview.find(params[:id])
        if @interview.destroy
            redirect_to "/interviews"
        else
            render json: @interview.errors, status: :unprocessable_entity
        end
    end
    def create
        count = 0;
        participant = interview_params[:participants].split(',')
        if interview_params[:end] < interview_params[:start]
            return render json: {"error": "End time must be greater than start time"}
        end
        participant.each do |item|
            @person = Person.find_by_email(item)
            if @person.nil?
            else
                puts "Printing interviews of people"
                @diff = @person.attributes.merge({"interviews" => @person.interviews})
                @diff["interviews"].each do |item|
                    if (interview_params[:start] < item.start && interview_params[:end] < item.start) || (interview_params[:start] > item.end && interview_params[:end] > item.end)
                        puts "If condition"
                        #Interview not overlapping
                    else
                        puts "Else Condition"
                        print @diff["interviews"][0].title
                        count = count+1
                        #interview overlapping
                    end
                end
            end
        end
        if count == 0
            @interviews = Interview.create(interview_params.except(:participants))
            d = interview_params[:start]
            # start = DateTime.new(d.year,d.month,d.day,d.hour,d.min,d.sec,d.zone).utc.to_i
            # e = DateTime.now
            # End = DateTime.new(e.year,e.month,e.day,e.hour,e.min,e.sec,e.zone).utc.to_i
            # min = start-End-30.minutes
            puts "Finding seconds"
            #print min
            puts "Minutes above"
            # mail = ReminderMail.perform_at(min.minutes.from_now, params[:id], participant, params[:start])
            participant.each do |item|
                person = Person.where(email: item)
                id = 0
                if person.empty?
                    @person = Person.create(email: item)
                    id = @person[:id]
                    print id
                    @interviews.people << @person
                else
                    id = person.pluck(:id)
                    print id
                    @interviews.people << person
                end
            end
            redirect_to "/interviews"
        else
            render json: {"error": "Time overlapping Detected. Records not added!"}
        end
    end
    private
        def interview_params
            params.permit(:start, :end, :title, :resume, :participants)
        end
        def update_params
            params.permit(:start, :end, :title, :participants)
        end
end