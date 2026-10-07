class HomeController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  def index
    @skills = Skill.all
    @projects = Project.all
    @experiences = Experience.all
    @educations = Education.all
  end
end
