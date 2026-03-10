class DiaryEntrySideEffectsController < ApplicationController
  before_action :set_user
  before_action :require_own_user
  before_action :set_diary_entry
  before_action :set_diary_entry_side_effect, only: :destroy

  def create
    side_effect_params = diary_entry_side_effect_params
    side_effect_params[:side_effect_id] = nil if side_effect_params[:side_effect_id] == "new"

    side_effect = @diary_entry.diary_entry_side_effects.new side_effect_params

    if side_effect.save
      redirect_to user_diary_entry_path(@user, @diary_entry)
    else
      redirect_to user_diary_entry_path(@user, @diary_entry), status: :unprocessable_content
    end
  end

  def destroy
    @dese.destroy!

    redirect_to user_diary_entry_path(@user, @diary_entry)
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def require_own_user
      redirect_to root_path, alert: "Go awayyyy" unless @user.id == Current.user.id
    end

    def set_diary_entry
      @diary_entry = @user.diary_entries.find(params[:diary_entry_id])
    end

    def set_diary_entry_side_effect
      @dese = @diary_entry.diary_entry_side_effects.find(params[:id])
    end

    def diary_entry_side_effect_params
      params.expect(diary_entry_side_effect: [
        :side_effect_id, :severity, :notes,
        side_effect_attributes: [ :name ]
      ])
    end
end
