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
			  status: "a" * 51,

        skype: "christianclough",
        linkedin: "christian.clough",

        education1: "Imperial",
        education2: "Oxford",
        education3: "Cambridge",
        experience1: "MRC-T",
        experience2: "WHO",
        experience3: "Candesic",

        education1_from: randomDate(:year_range => 3, :year_latest => 1),
        education1_to: randomDate(:year_range => 3, :year_latest => 1),
        education2_from: randomDate(:year_range => 3, :year_latest => 1),
        education2_to: randomDate(:year_range => 3, :year_latest => 1),
        education3_from: randomDate(:year_range => 3, :year_latest => 1),
        education3_to: randomDate(:year_range => 3, :year_latest => 1),

        experience1_from: randomDate(:year_range => 3, :year_latest => 1),
        experience1_to: randomDate(:year_range => 3, :year_latest => 1),
        experience2_from: randomDate(:year_range => 3, :year_latest => 1),
        experience2_to: randomDate(:year_range => 3, :year_latest => 1),
        experience3_from: randomDate(:year_range => 3, :year_latest => 1),
        experience3_to: randomDate(:year_range => 3, :year_latest => 1),

			  accepts_tandc: true)

admin.toggle!(:approved)
admin.toggle!(:completed)
admin.toggle!(:admin)