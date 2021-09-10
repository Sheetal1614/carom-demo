# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Adding User and Team
user_1 = User.create(fmno: 177266, name: 'Praveen Kumar Sinha', email: 'praveen_kumar_sinha@mckinsey.com', password: User::DEFAULT_PA55W0RD, password_confirmation: User::DEFAULT_PA55W0RD, application_admin: true)
RequestInfo.current_user = user_1

team_1 = Team.create(name: 'Team One from seed')
team_1.team_leaders << user_1