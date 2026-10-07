class ProjectsController < ApplicationController
    
    before_action :set_project, only: %i[update destroy edit]

    
    def index
        @projects = Project.all
    end

    def new
        @project = Project.new
    end

    def create
        @project = Project.new(project_params)
        if @project.save
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @project.update(project_params)
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        @project.destroy

        redirect_to root_path

    end

    private
    def project_params
        params.expect(project: [ :title, :description, :github_url])
    end

    def set_project
        @project = Project.find(params[:id])
    end
end
