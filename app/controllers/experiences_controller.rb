class ExperiencesController < ApplicationController
    before_action :set_experience, only: %i[update destroy edit]

    def index
        @experiences = Experience.all
    end

    def new
        @experience = Experience.new
    end

    def create

        @experience = Experience.new(experience_params)

        if @experience.save
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update

        if @experience.update(experience_params)
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy

        @experience.destroy

        redirect_to root_path
    end

    private

    def experience_params
        params.expect(experience: [:company, :position, :description, :period])
    end

    def set_experience
        @experience = Experience.find(params[:id])
    end

end
