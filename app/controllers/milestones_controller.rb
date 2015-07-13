class MilestonesController < ApplicationController
  def index
    @milestones = current_user.milestones
  end
end
