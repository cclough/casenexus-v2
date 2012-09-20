namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do

    100.times do |n|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = "example#{n+1}@casenexus.com"
      password = "password"
      lat = -90 + rand(180)
      lng = -180 + rand(360)
      status = Faker::Lorem.sentence(20)
      skype = "skpye"
      linkedin = "christian.clough@gmail.com"

      education1 = "Imperial"
      education2 = "Oxford"
      education3 = "Cambridge"
      experience1 = "MRC-T"
      experience2 = "WHO"
      experience3 = "Candesic"

      education1_to = randomDate(:year_range => 3, :year_latest => 1)
      education1_from = randomDate(:year_range => 3, :year_latest => 1)
      education2_to = randomDate(:year_range => 3, :year_latest => 1)
      education2_from = randomDate(:year_range => 3, :year_latest => 1)
      education3_to = randomDate(:year_range => 3, :year_latest => 1)
      education3_from = randomDate(:year_range => 3, :year_latest => 1)

      experience1_to = randomDate(:year_range => 3, :year_latest => 1)
      experience1_from = randomDate(:year_range => 3, :year_latest => 1)
      experience2_to = randomDate(:year_range => 3, :year_latest => 1)
      experience2_from = randomDate(:year_range => 3, :year_latest => 1)
      experience3_to = randomDate(:year_range => 3, :year_latest => 1)
      experience3_from = randomDate(:year_range => 3, :year_latest => 1)

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

    admin2 = User.create!(
           first_name: "Robin",
           last_name: "Clough",
           email: "robin.clough@gmail.com",
           password: "numbnuts",
           password_confirmation: "numbnuts",
           lat: 51.9128232665856,
           lng: -1.541188764572144,
           status: Faker::Lorem.sentence(20),

           skype: "robinclough",
           linkedin: "christian.clough@gmail.com",

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
           status: Faker::Lorem.sentence(20),

           skype: "greatdesign",
           linkedin: "great.design@linkedin.com",

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

    designer.toggle!(:approved)
    designer.toggle!(:completed)


    User.all.each do |user|

      rand(60).times do
        user.cases.create!(
          :interviewer_id => rand(1..100),
          :date => randomDate(:year_range => 2, :year_latest => 0.5),
          :subject => Faker::Lorem.sentence(5),
          :source => Faker::Lorem.sentence(5),    
          :structure => rand(1..10),
          :structure_comment => Faker::Lorem.sentence(5),
          :analytical => rand(1..10),
          :analytical_comment => Faker::Lorem.sentence(5),
          :commercial => rand(1..10),
          :commercial_comment => Faker::Lorem.sentence(5),
          :conclusion => rand(1..10),
          :conclusion_comment => Faker::Lorem.sentence(5),
          :comment => Faker::Lorem.sentence(5),
          :notes => Faker::Lorem.sentence(5)
        )
      end

    end



    User.all.each do |user|
      
      # no longer needed as automatically created by after_create in user
      #user.notifications.create!(sender_id: 1, :ntype => "welcome")

      10.times do
        user.notifications.create!(:ntype => "message",
                                   :sender_id => rand(1..100), 
                                   :content => Faker::Lorem.sentence(5))
        ## created in case.rb
        # user.notifications.create!(:ntype => "feedback_new",
        #                            :sender_id => rand(1..100), 
        #                            :content => Faker::Lorem.sentence(5),
        #                            :event_date => randomDate(:year_range => 1, :year_latest => 0),
        #                            :case_id => rand(1000))
        user.notifications.create!(:ntype => "feedback_request",
                                   :sender_id => rand(1..100), 
                                   :content => Faker::Lorem.sentence(5),
                                   :event_date => randomDate(:year_range => 1, :year_latest => 0))
      end
    end

    Notification.all.each do |notification|

      if rand(2) == 1
        notification.read == true
      end

    end


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