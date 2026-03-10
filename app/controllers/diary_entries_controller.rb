class DiaryEntriesController < ApplicationController
  before_action :set_user
  before_action :require_own_user
  before_action :set_diary_entry, except: %i[ index new create ]

  def index
    @diary_entries = @user.diary_entries.order(entry_for: :desc)
  end

  def new
    time = case Time.current.hour
    when 0..6
      "Night"
    when 6..11
      "Morning"
    when 12..13
      "Midday"
    when 15..17
      "Afternoon"
    when 18..21
      "Evening"
    else
      "Night"
    end
  @diary_entry = @user.diary_entries.new(entry_for: DateTime.current, title: "#{time} thoughts")
  end

  def create
    # the voices are getting louder
    @diary_entry = @user.diary_entries.new diary_entry_params

    if @diary_entry.save
      redirect_to user_diary_entry_path(@user, @diary_entry)
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def edit
    @diary_entry.diary_entry_side_effects.build
  end

  def update
    if @diary_entry.update diary_entry_params
      redirect_to user_diary_entry_path(@user, @diary_entry)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @diary_entry.destroy!

    redirect_to user_diary_entries_path(@user)
  end

  private
    def diary_entry_params
      params.expect(diary_entry: [ :title, :body, :entry_for ])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def require_own_user
      redirect_to root_path, alert: "Am angwy" unless @user.id == Current.user.id
    end

    def set_diary_entry
      @diary_entry = @user.diary_entries.find(params[:id])
    end
end
