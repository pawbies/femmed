class PushSubscriptionsController < ApplicationController
  def create
    subscription = Current.user.push_subscriptions.find_or_initialize_by(endpoint: params[:endpoint])
    subscription.update!(p256dh: params.dig(:keys, :p256dh), auth: params.dig(:keys, :auth))

    head :ok
  end

  def destroy
    Current.user.push_subscriptions.find_by(endpoint: params[:endpoint])&.destroy

    head :ok
  end
end
