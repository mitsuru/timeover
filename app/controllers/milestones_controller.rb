class MilestonesController < ApplicationController
  def index
    @milestones = current_user.milestones
  end

  def new
    @milestone = Milestone.new
  end
end
