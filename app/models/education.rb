class Education < ApplicationRecord
    validates :institution, presence: true
    validates :qualification, presence: true
end
