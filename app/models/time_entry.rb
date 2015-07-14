class TimeEntry < ActiveRecord::Base
  belongs_to :user

  def url
    data = parse_json
    data["task"]["url"]
  end

  def parse_json
    @parsed ||= JSON.parse(self.json)
  end
end
