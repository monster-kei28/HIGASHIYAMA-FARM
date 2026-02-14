# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
harvest_experiences = [
  { title: "さつまいも掘り" },
  { title: "みかん狩り" },
  { title: "いちご狩り" }
]

harvest_experiences.each do |attrs|
  HarvestExperience.find_or_create_by!(title: attrs[:title])
end

first_admin_uid = ENV["FIRST_ADMIN_UID"]

if first_admin_uid.present?
  Admin.find_or_create_by!(uid: first_admin_uid)
else
  Rails.logger.warn("[seed] FIRST_ADMIN_UID is not set. Admin is not created.")
end
