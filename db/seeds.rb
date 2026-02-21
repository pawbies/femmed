# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[
  {name: "Methylphenidathydrochlorid"}
].each do |a|
  ActiveIngredient.find_or_create_by(name: a[:name])
end

[
  {name: "Novartis"}
].each do |l|
  Labeler.find_or_create_by(name: l[:name])
end

[
  {name: "Capsules"}
].each do |f|
  Form.find_or_create_by(name: f[:name])
end

[
  {
    name: "Ritalin LA",
    labeler: Labeler.find_by(name: "Novartis"),
    form: Form.find_by(name: "Capsules")
  },
  {
    name: "Ritalin IR",
    labeler: Labeler.find_by(name: "Novartis"),
    form: Form.find_by(name: "Capsules")
  }
].each do |m|
  Medication.find_or_create_by(name: m[:name]) do |medication|
    medication.labeler = m[:labeler]
    medication.form = m[:form]
  end
end

