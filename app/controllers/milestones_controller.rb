class MilestonesController < ApplicationController
  load_and_authorize_resource

  def index
    @milestones = current_user.milestones
    @duration = current_user.time_entries.sum(:duration)
  end

  def new
    @milestone = current_user.milestones.build
  end

  def create
    @milestone = current_user.milestones.build(milestone_params)
  end

  def edit
    @milestone = current_user.milestones.find(params[:id])
  end

  def update
    @milestone = current_user.milestones.find(params[:id])
    if @milestone.update(milestone_params)
      redirect_to milestones_path
    else
      render :edit
    end
  end

  private
  def milestone_params
    params.require(:milestone).permit(:title, :start_at, :state)
  end
end
