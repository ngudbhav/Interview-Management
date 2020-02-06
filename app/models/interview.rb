class Interview < ApplicationRecord
    has_one_attached :resume
    has_and_belongs_to_many :people
    validates :resume, :start, :end, :title, presence: true
end