class PushNotificationService
  def initialize(user:, title:, body:, url: "/")
    @user  = user
    @title = title
    @body  = body
    @url   = url
  end

  def call
    @user.push_subscriptions.find_each do |sub|
      send_to(sub)
    rescue WebPush::ExpiredSubscription
      sub.destroy
    end
  end

  private

  def send_to(sub)
    WebPush.payload_send(
      message: payload,
      endpoint: sub.endpoint,
      p256dh: sub.p256dh,
      auth: sub.auth,
      vapid: {
        subject:     "mailto:contact@pawbies.net",
        public_key:  ENV["VAPID_PUBLIC_KEY"],
        private_key: ENV["VAPID_PRIVATE_KEY"]
      }
    )
  end

  def payload
    { title: @title, body: @body, url: @url }.to_json
  end
end
