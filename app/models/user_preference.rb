class UserPreference < ActiveRecord::Base
  belongs_to :user

  typed_store :preferences do |t|
    t.datetime :start
  end
end
