class SkillsController < ApplicationController

    before_action :set_skill, only: %i[ update destroy edit]

    def index
        @skills = Skill.all
    end

    def new
        @skill = Skill.new
    end

    def create
        @skill = Skill.new(skill_params)

        if @skill.save
            redirect_to root_path # Redirect to home page
        else
            # Stay on the "add skill" page, form still filled in
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @skill.update(skill_params)
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        @skill.destroy

        redirect_to root_path
    end

    private

    def skill_params
        params.expect(skill: [ :name, :category])
    end

    def set_skill
        @skill = Skill.find(params[:id])
    end
end