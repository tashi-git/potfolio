class EducationsController < ApplicationController

    before_action :set_education, only: %i[update destroy edit]
    
    def index
        @educations = Education.all
    end

    def new
        @education = Education.new
    end

    def create

        @education = Education.new(education_params)

        if @education.save
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @education.update(education_params)
            redirect_to root_path
        else
            render :new, status: unprocessable_entity
        end
    end

    def destroy

        @education.destroy

        redirect_to root_path

    end

    private

    def education_params
        params.expect(education: [:institution, :qualification])
    end

    def set_education
        @education = Education.find(params[:id])
    end
end
