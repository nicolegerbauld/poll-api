# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
p "Seeding 20 Posts"

20.times do |x|
  Post.create!  title: Faker::Music.band,
    content: Faker::Music.album,
    like: Faker::Number.between(from: 1, to: 10)
end
