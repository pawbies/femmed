require Rails.root.join("lib/permissions_policy_naming")

Rails.application.config.permissions_policy do |policy|
  policy.camera      :none
  policy.gyroscope   :none
  policy.microphone  :none
  policy.usb         :none
  policy.fullscreen  :none
  policy.payment     :none
end


Rails.application.config.middleware.insert_after(
  ActionDispatch::PermissionsPolicy::Middleware,
  PermissionsPolicyNaming
)
