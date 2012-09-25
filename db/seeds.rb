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



University.create!(name: "University of Cambridge", image: "cambridge.gif")
University.create!(name: "University of Oxford", image: "oxford.jpg")
University.create!(name: "Harvard College", image: "harvard.gif")