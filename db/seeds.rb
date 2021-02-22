# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Adding User and Accounts
almighty_1 = Almighty.create(name: 'Praveen', email: 'praveen_kumar_sinha@mckinsey.com', password: 'password', password_confirmation: 'password')
account_1 = almighty_1.accounts.create(name: 'Akkad')

almighty_2 = Almighty.create(name: 'Some one', email: 'some_one@mckinsey.com', password: 'password', password_confirmation: 'password')
account_2 = almighty_2.accounts.create(name: 'Bakkad')
