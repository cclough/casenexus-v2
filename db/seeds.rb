if %w(production development).include?(Rails.env) && User.count == 0
  
  puts "Creating universities"

  University.create!(name: "University of Cambridge", image: "cambridge.gif", domain: "cam.ac.uk")
  University.create!(name: "University of Oxford", image: "oxford.jpg", domain: "ox.ac.uk")
  University.create!(name: "Harvard University", image: "harvard.gif", domain: "harvard.edu")
  University.create!(name: "Harvard Business School", image: "harvard.gif", domain: "hbs.edu")
  University.create!(name: "UC San Diego - Rady", image: "harvard.gif", domain: "rady.ucsd.edu")
  University.create!(name: "UC San Diego", image: "harvard.gif", domain: "ucsd.edu")
  University.create!(name: "Northerwestern University - Kellogg", image: "harvard.gif", domain: "kellogg.northwestern.edu")
  University.create!(name: "UC Berkeley", image: "harvard.gif", domain: "berkeley.edu")
  University.create!(name: "UC Berkeley - Haas", image: "harvard.gif", domain: "haas.berkeley.edu")
  University.create!(name: "UPenn", image: "harvard.gif", domain: "upenn.edu")
  University.create!(name: "UPenn - Wharton", image: "harvard.gif", domain: "wharton.upenn.edu")
  University.create!(name: "London School of Economics", image: "harvard.gif", domain: "lse.ac.uk")
  University.create!(name: "Imperial College London", image: "harvard.gif", domain: "imperial.ac.uk")
  University.create!(name: "Stanford University", image: "harvard.gif", domain: "stanford.edu")
  University.create!(name: "Columbia University", image: "harvard.gif", domain: "columbia.edu")
  University.create!(name: "Cornell University", image: "harvard.gif", domain: "cornell.edu")
  University.create!(name: "Brown University", image: "harvard.gif", domain: "brown.edu")
  University.create!(name: "Dartmouth College", image: "harvard.gif", domain: "dartmouth.edu")
  University.create!(name: "Princeton University", image: "harvard.gif", domain: "princeton.edu")

  puts "Creating christian's user"

  admin = User.new(
      first_name: "Christian",
      last_name: "Clough",
      email: "casenexus@cam.ac.uk",
      password: "houseoflies26?",
      password_confirmation: "houseoflies26?",
      lat: 51.5100,
      lng: -0.1344,
      status: "Interviewing with BCG and Bain in the next few months, looking to practise on Weekday evenings after 9pm and weekends",
      invitation_code: 'BYPASS_CASENEXUS_INV',

      skype: "christianclough",

      confirm_tac: true,

      ip_address: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)])
  admin.status_approved = true
  admin.completed = true
  admin.admin = true
  admin.save!
  admin.confirm!

  puts "Creating alastair's user"

  admin = User.new(
      first_name: "Alastair",
      last_name: "Willey",
      email: "alastair.willey@cam.ac.uk",
      password: "design",
      password_confirmation: "design",
      lat: 51.90128232665856,
      lng: -0.5421188764572144,
      status: Faker::Lorem.sentence(20),
      invitation_code: 'BYPASS_CASENEXUS_INV',

      skype: "",

      confirm_tac: true,

      ip_address: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)])
  admin.status_approved = true
  admin.completed = true
  admin.admin = true
  admin.save!
  admin.confirm!

  puts "Creating robin's user"

  admin = User.new(
      first_name: "Robin",
      last_name: "Clough",
      email: "robin.clough@rady.ucsd.edu",
      password: "T266vjsd",
      password_confirmation: "T266vjsd",
      lat: 32.869627,
      lng: -117.221015,
      status: "First-year MBA student at Rady school of Management - UCSD. I am applying to the top firms on both sides of the Atlantic for my MBA internship.",
      invitation_code: 'BYPASS_CASENEXUS_INV',

      skype: "cloughrobin",

      confirm_tac: true,

      ip_address: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)])

  admin.status_approved = true
  admin.completed = true
  admin.admin = true
  admin.save!
  admin.confirm!


  puts "Creating Christian's Friendships"

  Friendship.connect(User.find(1), User.find(2))
  Friendship.connect(User.find(1), User.find(3))



  puts "Creating countries"

  file = "#{Rails.root}/db/countries.csv"

  require 'csv'

  CSV.foreach(file, headers: true) do |row|
    Country.create!(
        name: row[0],
        code: row[1],
        lat: row[2],
        lng: row[3]
    )
  end


end

if Rails.env == 'development'

  def random_date(params={ })
    years_back = params[:year_range] || 5
    latest_year = params [:year_latest] || 0
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

  15.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = "example#{n+1}@cam.ac.uk"
    password = "password"
    lat = -90 + rand(180)
    lng = -180 + rand(360)
    status = Faker::Lorem.sentence(20)
    skype = "skpye"

    confirm_tac = true

    ip_address = "%d.%d.%d.%d" % [rand(255) + 1, rand(256), rand(256), rand(256)]

    user = User.new(first_name: first_name, last_name: last_name,
                    email: email, password: password,
                    password_confirmation: password,
                    lat: lat, lng: lng, status: status,
                    skype: skype,
                    confirm_tac: confirm_tac,
                    ip_address: ip_address,
                    invitation_code: 'BYPASS_CASENEXUS_INV')

    user.status_approved = true
    user.completed = true
    user.save!
    user.confirm!

    puts "User #{user.name} created"
  end

  User.all.each do |user|

    rand(51).times do
      interviewer_id = 1 + rand(15)
      next if interviewer_id.to_i == user.id.to_i
      user.cases.create!(
          interviewer_id: interviewer_id,
          date: random_date(year_range: 2, year_latest: 0.5),
          subject: Faker::Lorem.sentence(5),
          source: Faker::Lorem.sentence(3),

          recommendation1: Faker::Lorem.sentence(10),
          recommendation2: Faker::Lorem.sentence(10),
          recommendation3: Faker::Lorem.sentence(10),

          structure_comment: Faker::Lorem.sentence(30),
          businessanalytics_comment: Faker::Lorem.sentence(30),
          interpersonal_comment: Faker::Lorem.sentence(30),

          quantitativebasics: 1 + rand(9),
          problemsolving: 1 + rand(9),
          prioritisation: 1 + rand(9),
          sanitychecking: 1 + rand(9),

          rapport: 1 + rand(9),
          articulation: 1 + rand(9),
          concision: 1 + rand(9),
          askingforinformation: 1 + rand(9),

          approachupfront: 1 + rand(9),
          stickingtostructure: 1 + rand(9),
          announceschangedstructure: 1 + rand(9),
          pushingtoconclusion: 1 + rand(9)
      )
      puts "Case created for user #{user.name}"
    end

  end

  User.all.each do |user|

    2.times do
      sender_id = rand(15) + 1
      next if user.id.to_s == sender_id.to_s
      user.notifications.create!(ntype: "message",
                                 sender_id: sender_id,
                                 content: Faker::Lorem.sentence(5))

      puts "Message Notifications created for user #{user.name}"
    end
  end

  Notification.all.each do |notification|
    if rand(2) == 1
      notification.read!
      puts "Notification marked as read"
    end
  end

end

