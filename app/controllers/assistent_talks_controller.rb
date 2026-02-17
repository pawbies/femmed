class AssistentTalksController < ApplicationController
  def create
    talk = AssistentTalk.new(user: Current.user, talk: assistent_talk_params)

    unless talk.save
      flash.now[:alert] = "Assistent talk couldn't be saved :("
    end

    redirect_back fallback_location: root_path
  end

  private
    def assistent_talk_params
      params.permit(:talk)[:talk]
    end
end
