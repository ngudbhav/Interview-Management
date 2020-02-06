class CreateInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :interviews do |t|
      t.datetime :start
      t.datetime :end
      t.string :title

      t.timestamps
    end
  end
end
