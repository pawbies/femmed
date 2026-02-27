module EnvConfig
  PUBLIC = ActiveModel::Type::Boolean.new.cast(ENV.fetch("FEMMED_PUBLIC", "false"))
end
