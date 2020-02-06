class CreateJoinTableInterviewsPeople < ActiveRecord::Migration[6.0]
  def change
    create_join_table :interviews, :people do |t|
      # t.index [:interview_id, :person_id]
      # t.index [:person_id, :interview_id]
    end
  end
end
