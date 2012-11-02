if User.count == 0 && Rails.env != 'test'
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

      confirm_tac: true,

      ip_address: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)])
  admin.toggle!(:status_approved)
  admin.toggle!(:completed)
  admin.toggle!(:admin)
  admin.confirm!

  puts "Admin #{admin.name} created"

  admin2 = User.create!(
      first_name: "Rodrigo",
      last_name: "D",
      email: "rorra.rorra@gmail.com",
      password: "password",
      password_confirmation: "password",
      lat: 51.01128232665856,
      lng: -0.4241188764572144,
      status: Faker::Lorem.sentence(20),

      skype: "rdominguez81",

      confirm_tac: true,

      ip_address: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)])

  admin2.toggle!(:status_approved)
  admin2.toggle!(:completed)
  admin2.toggle!(:admin)
  admin2.confirm!

  puts "Admin #{admin2.name} created"

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

      confirm_tac: true,

      ip_address: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)])

  admin3.toggle!(:status_approved)
  admin3.toggle!(:completed)
  admin3.toggle!(:admin)
  admin3.confirm!

  puts "Admin #{admin3.name} created"

  admin4 = User.create!(
      first_name: "Nicola",
      last_name: "Rowe",
      email: "nicolarowe@mac.com",
      password: "clarecollege",
      password_confirmation: "clarecollege",
      lat: -43.531637,
      lng: 172.636645,
      status: Faker::Lorem.sentence(20),

      confirm_tac: true,

      ip_address: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)])

  admin4.toggle!(:status_approved)
  admin4.toggle!(:completed)
  admin4.toggle!(:admin)
  admin4.confirm!

  puts "Admin #{admin4.name} created"

  University.create!(name: "University of Cambridge", image: "cambridge.gif", domain: "cam.ac.uk")
  University.create!(name: "University of Oxford", image: "oxford.jpg", domain: "ox.ac.uk")
  University.create!(name: "Harvard College", image: "harvard.gif", domain: "harvard.edu")

  puts "Universities created"

  # Friendships
  users = User.order(:id).all
  Friendship.connect(users[0], users[1])
  Friendship.connect(users[0], users[2])
  Friendship.connect(users[0], users[3])

  puts "Friendships created"
end

if Rails.env != 'test'

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
    email = "example#{n+1}@casenexus.com"
    password = "password"
    lat = -90 + rand(180)
    lng = -180 + rand(360)
    status = Faker::Lorem.sentence(20)
    skype = "skpye"

    confirm_tac = true

    ip_address = "%d.%d.%d.%d" % [rand(255) + 1, rand(256), rand(256), rand(256)]

    user = User.create!(first_name: first_name, last_name: last_name,
                        email: email, password: password,
                        password_confirmation: password,
                        lat: lat, lng: lng, status: status,
                        skype: skype,
                        confirm_tac: confirm_tac,
                        ip_address: ip_address)

    user.toggle!(:status_approved)
    user.toggle!(:completed)
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
end

