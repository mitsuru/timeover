class PreferencesController < ApplicationController
  def show
    current_user.build_preferences if current_user.preferences.nil?
    @preferences = current_user.preferences
  end

  def edit
    current_user.build_preferences if current_user.preferences.nil?
    @preferences = current_user.preferences
  end

  def update
    current_user.preferences.update(preferences_params)
  end

  private
  def preferences_params
    params.require(:preferences).permit(:start)
  end
end
