# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

profile_admin = 'Admin'
profile = Profile.create!(name: profile_admin, admin: true) unless Profile.where(name: profile_admin).present?

User.create!(
  name: 'User', email: 'dev@dev.com', cpf: '00000000000', password: 'password',
  password_confirmation: 'password', profile_id: Profile.find_by(name: profile_admin).id
) unless User.where(email: 'dev@dev.com').present?

Acl::AppModule.verify_modules
