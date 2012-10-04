# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create!(
        first_name: "Christian",
	    last_name: "Clough",
        email: "christian.clough@gmail.com",
        password: "numbnuts",
        password_confirmation: "numbnuts",
        lat: 51.901128232665856,
        lng: -0.54241188764572144,
        status: Faker::Lorem.sentence(20),

        skype: "christianclough",
        linkedin: "christian.clough@linkedin.com",

        accepts_tandc: true)

admin.toggle!(:approved)
admin.toggle!(:completed)
admin.toggle!(:admin)

admin2 = User.create!(
        first_name: "Rodrigo",
        last_name: "D",
        email: "rodrigo@rodrigo.com",
        password: "rodrigo",
        password_confirmation: "rodrigo",
        lat: 51.01128232665856,
        lng: -0.4241188764572144,
        status: Faker::Lorem.sentence(20),

        skype: "rodrigo",
        linkedin: "rodrigo@rodrigo.com",

        accepts_tandc: true)

admin2.toggle!(:approved)
admin2.toggle!(:completed)
admin2.toggle!(:admin)

admin3 = User.create!(
        first_name: "Design",
        last_name: "Pro",
        email: "design@design.com",
        password: "design",
        password_confirmation: "design",
        lat: 51.3128232665856,
        lng: -0.941188764572144,
        status: Faker::Lorem.sentence(20),

        skype: "greatdesign",
        linkedin: "great.design@linkedin.com",

        accepts_tandc: true)

admin3.toggle!(:approved)
admin3.toggle!(:completed)

admin4 = User.create!(
        first_name: "Nicola",
        last_name: "Rowe",
        email: "nicolarowe@mac.com",
        password: "clarecollege",
        password_confirmation: "clarecollege",
        lat: -43.531637,
        lng: 172.636645,
        status: Faker::Lorem.sentence(20),

        accepts_tandc: true)

admin4.toggle!(:approved)
admin4.toggle!(:completed)


University.create!(name: "University of Cambridge", image: "cambridge.gif", domain: "cam.ac.uk")
University.create!(name: "University of Oxford", image: "oxford.jpg", domain: "ox.ac.uk")
University.create!(name: "Harvard College", image: "harvard.gif", domain: "harvard.edu")

# Friendships
User.find(1) do |user|

  user.invite User.find(2)
  User.find(2).approve user
  user.invite User.find(3)
  User.find(3).approve user
  user.invite User.find(4)
  User.find(4).approve user

end

User.find(4) do |user|

  user.invite User.find(1)
  User.find(1).approve user

end
