namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do

    98.times do |n|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = "example#{n+1}@casenexus.com"
      password = "password"
      lat = -90 + rand(180)
      lng = -180 + rand(360)
      status = "#{n}" * 51
      skype = "skye"
      linkedin = "christian.clough"

      education1 = "Imperial"
      education2 = "Oxford"
      education3 = "Cambridge"
      experience1 = "MRC-T"
      experience2 = "WHO"
      experience3 = "Candesic"

      education1_to = randomDate(:year_range => 3, :year_latest => 0)
      education1_from = randomDate(:year_range => 3, :year_latest => 0)
      education2_to = randomDate(:year_range => 3, :year_latest => 0)
      education2_from = randomDate(:year_range => 3, :year_latest => 0)
      education3_to = randomDate(:year_range => 3, :year_latest => 0)
      education3_from = randomDate(:year_range => 3, :year_latest => 0)

      experience1_to = randomDate(:year_range => 3, :year_latest => 0)
      experience1_from = randomDate(:year_range => 3, :year_latest => 0)
      experience2_to = randomDate(:year_range => 3, :year_latest => 0)
      experience2_from = randomDate(:year_range => 3, :year_latest => 0)
      experience3_to = randomDate(:year_range => 3, :year_latest => 0)
      experience3_from = randomDate(:year_range => 3, :year_latest => 0)

      accepts_tandc = true

      User.create!(first_name: first_name, last_name: last_name,
               email: email, password: password,
               password_confirmation: password,
               lat: lat, lng: lng, status: status,
               skype: skype, linkedin: linkedin,
               education1: education1, education2: education2,
               education3: education3, experience1: experience1,
               experience2: experience2, experience3: experience3,
               education1_from: education1_from, education1_to: education1_to,
               education2_from: education2_from, education2_to: education2_to,
               education3_from: education3_from, education3_to: education3_to,
               experience1_from: education1_from, experience1_to: education1_to,
               experience2_from: education2_from, experience2_to: education2_to,
               experience3_from: education3_from, experience3_to: education3_to,
               accepts_tandc: accepts_tandc)

    end

    User.all.each do |user|

      if rand(2) == 1
        user.toggle!(:approved)
      end

      if rand(2) == 1
        user.toggle!(:completed)
      end

    end


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

           education1_from: randomDate(:year_range => 3, :year_latest => 0),
           education1_to: randomDate(:year_range => 3, :year_latest => 0),
           education2_from: randomDate(:year_range => 3, :year_latest => 0),
           education2_to: randomDate(:year_range => 3, :year_latest => 0),
           education3_from: randomDate(:year_range => 3, :year_latest => 0),
           education3_to: randomDate(:year_range => 3, :year_latest => 0),

           experience1_from: randomDate(:year_range => 3, :year_latest => 0),
           experience1_to: randomDate(:year_range => 3, :year_latest => 0),
           experience2_from: randomDate(:year_range => 3, :year_latest => 0),
           experience2_to: randomDate(:year_range => 3, :year_latest => 0),
           experience3_from: randomDate(:year_range => 3, :year_latest => 0),
           experience3_to: randomDate(:year_range => 3, :year_latest => 0),

					 accepts_tandc: true)

    admin.toggle!(:approved)
    admin.toggle!(:completed)
    admin.toggle!(:admin)

    admin2 = User.create!(
           first_name: "Robin",
           last_name: "Clough",
           email: "robin.clough@gmail.com",
           password: "numbnuts",
           password_confirmation: "numbnuts",
           lat: 51.9128232665856,
           lng: -0.541188764572144,
           status: "b" * 51,

           skype: "robinclough",
           linkedin: "robin.clough",

           education1: "Imperial",
           education2: "Oxford",
           education3: "Cambridge",
           experience1: "MRC-T",
           experience2: "WHO",
           experience3: "Candesic",

           education1_from: randomDate(:year_range => 3, :year_latest => 0),
           education1_to: randomDate(:year_range => 3, :year_latest => 0),
           education2_from: randomDate(:year_range => 3, :year_latest => 0),
           education2_to: randomDate(:year_range => 3, :year_latest => 0),
           education3_from: randomDate(:year_range => 3, :year_latest => 0),
           education3_to: randomDate(:year_range => 3, :year_latest => 0),

           experience1_from: randomDate(:year_range => 3, :year_latest => 0),
           experience1_to: randomDate(:year_range => 3, :year_latest => 0),
           experience2_from: randomDate(:year_range => 3, :year_latest => 0),
           experience2_to: randomDate(:year_range => 3, :year_latest => 0),
           experience3_from: randomDate(:year_range => 3, :year_latest => 0),
           experience3_to: randomDate(:year_range => 3, :year_latest => 0),

           accepts_tandc: true)

    admin2.toggle!(:approved)
    admin2.toggle!(:completed)
    admin2.toggle!(:admin)

    designer = User.create!(
           first_name: "Design",
           last_name: "Pro",
           email: "design@design.com",
           password: "design",
           password_confirmation: "design",
           lat: 51.9128232665856,
           lng: -0.541188764572144,
           status: "c" * 51,

           skype: "greatdesign",
           linkedin: "great.design",

           education1: "Imperial",
           education2: "Oxford",
           education3: "Cambridge",
           experience1: "MRC-T",
           experience2: "WHO",
           experience3: "Candesic",

           education1_from: randomDate(:year_range => 3, :year_latest => 0),
           education1_to: randomDate(:year_range => 3, :year_latest => 0),
           education2_from: randomDate(:year_range => 3, :year_latest => 0),
           education2_to: randomDate(:year_range => 3, :year_latest => 0),
           education3_from: randomDate(:year_range => 3, :year_latest => 0),
           education3_to: randomDate(:year_range => 3, :year_latest => 0),

           experience1_from: randomDate(:year_range => 3, :year_latest => 0),
           experience1_to: randomDate(:year_range => 3, :year_latest => 0),
           experience2_from: randomDate(:year_range => 3, :year_latest => 0),
           experience2_to: randomDate(:year_range => 3, :year_latest => 0),
           experience3_from: randomDate(:year_range => 3, :year_latest => 0),
           experience3_to: randomDate(:year_range => 3, :year_latest => 0),

           accepts_tandc: true)

    designer.toggle!(:approved)
    designer.toggle!(:completed)

  end

  private

	  def randomDate(params={})
	    years_back = params[:year_range] || 5
	    latest_year  = params [:year_latest] || 0
	    year = (rand * (years_back)).ceil + (Time.now.year - latest_year - years_back)
	    month = (rand * 12).ceil
	    day = (rand * 31).ceil
	    series = [date = Time.local(year, month, day)]
	    if params[:series]
	      params[:series].each do |some_time_after|
	        series << series.last + (rand * some_time_after).ceil
	      end
	      return series
	    end
	    date
	  end


end