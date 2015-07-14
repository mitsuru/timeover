class UserPreferencesController < ApplicationController
  def show
    current_user.build_preferences if current_user.preferences.nil?
    @user_preference = current_user.preferences
  end

  def edit
    current_user.create_preferences if current_user.preferences.nil?
    @user_preference = current_user.preferences
  end

  def update
    current_user.preferences.update(preferences_params)
    redirect_to user_preference_path
  end

  private
  def preferences_params
    params.require(:user_preference).permit(:start)
  end
end
