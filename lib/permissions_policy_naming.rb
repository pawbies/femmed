class PermissionsPolicyNaming
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    policy = Rails.application.config.permissions_policy
    if policy
      headers["permissions-policy"] = policy.directives.map { |feature, values| "#{feature.to_s.tr("_", "-")}=()" }.join(", ")
    end

    [ status, headers, body ]
  end
end
