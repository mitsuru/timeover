class MilestonesController < ApplicationController
  load_and_authorize_resource

  def index
    @milestones = current_user.milestones
    @duration = TimeEntry.sum(:duration)
  end

  def new
    @milestone = Milestone.new
  end
end
