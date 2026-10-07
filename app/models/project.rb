class Project < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    validates :github_url, presence: true
end
