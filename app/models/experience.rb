class Experience < ApplicationRecord
    validates :company, presence: true
    validates :position, presence: true
    validates :description, presence: true
    validates :period, presence: true
end
