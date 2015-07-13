class TimeEntriesController < ApplicationController
  def index
    @time_entries = TimeEntry.page(params[:page]).per(100)
  end

  def sync
  end
end
