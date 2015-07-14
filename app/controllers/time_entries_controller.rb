class TimeEntriesController < ApplicationController
  load_and_authorize_resource

  def index
    @time_entries = current_user.time_entries.page(params[:page]).per(100)
  end

  def sync
    client = OAuth2::Client.new(Figaro.env.timecrowd_client_id, Figaro.env.timecrowd_client_secret, site: Figaro.env.timecrowd_site, ssl: { verify: false })
    token = OAuth2::AccessToken.new(client, current_user.token)

    stopped_from = Time.local(2015,6,1).to_i
    @entries = token.get("api/v1/time_entries?stopped_from=#{stopped_from}&count=1000").parsed
    sync_time_entries(@entries)

    redirect_to :time_entries
  end

  def show
    @time_entry = TimeEntry.find(params[:id])
  end

  private
  def sync_time_entries(entries)
    entries.each do |e|
      time_entry = TimeEntry.find_or_initialize_by id: e["id"]
      time_entry.user = current_user
      time_entry.started_at = Time.at(e["started_at"])
      time_entry.stopped_at = Time.at(e["stopped_at"])
      time_entry.duration = e["duration"]
      time_entry.json = e.to_json
      time_entry.save
    end
  end
end
