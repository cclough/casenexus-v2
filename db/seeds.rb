if %w(production development).include?(Rails.env) && User.count == 0
  puts "Creating universities"

  University.create!(name: "University of Cambridge", image: "cambridge.gif", domain: "cam.ac.uk")
  University.create!(name: "University of Oxford", image: "oxford.jpg", domain: "ox.ac.uk")
  University.create!(name: "Harvard College", image: "harvard.gif", domain: "harvard.edu")

  puts "Creating christian's user"

  admin = User.new(
      first_name: "Christian",
      last_name: "Clough",
      email: "christian.clough@cam.ac.uk",
      password: "numbnuts",
      password_confirmation: "numbnuts",
      lat: 51.901128232665856,
      lng: -0.54241188764572144,
      status: Faker::Lorem.sentence(20),
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
  admin.save!
  admin.confirm!

  puts "Creating countries"

  file = "#{Rails.root}/db/countries.csv"

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

  100.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = "example#{n+1}@cam.ac.uk"
    password = "password"
    lat = -90 + rand(180)
    lng = -180 + rand(360)
    status = Faker::Lorem.sentence(20)
    skype = "skpye"
    invitation_code: 'BYPASS_CASENEXUS_INV'

    confirm_tac = true

    ip_address = "%d.%d.%d.%d" % [rand(255) + 1, rand(256), rand(256), rand(256)]

    user = User.new(first_name: first_name, last_name: last_name,
                    email: email, password: password,
                    password_confirmation: password,
                    lat: lat, lng: lng, status: status,
                    skype: skype,
                    confirm_tac: confirm_tac,
                    ip_address: ip_address)

    user.status_approved = true
    user.completed = true
    user.save!
    user.confirm!

    puts "User #{user.name} created"
  end

  User.limit(20).all.each do |user|

    rand(51).times do
      user.cases.create!(
          interviewer_id: 1 + rand(98),
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

  User.limit(20).each do |user|

    2.times do
      user.notifications.create!(ntype: "message",
                                 sender_id: rand(100),
                                 content: Faker::Lorem.sentence(5))

      puts "Message Notifications created for user #{user.name}"
    end

    user.cases.each do |kase|
      Notification.create!(ntype: 'feedback_req',
                           sender_id: kase.user,
                           user: kase.interviewer,
                           content: Faker::Lorem.paragraph,
                           notificable: kase)
      puts "Request feedback notificationcreated for case #{kase}"
    end
  end

  Notification.all.each do |notification|
    if rand(2) == 1
      notification.read!
      puts "Notification marked as read"
    end
  end

  puts "Creating Christian's Friendships"
  
  users = User.order(:id).all
  Friendship.connect(users[0], users[1])
  Friendship.connect(users[0], users[2])
  Friendship.connect(users[0], users[3])  

end

