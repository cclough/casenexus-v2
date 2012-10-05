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

      accepts_tandc = true

      ip_address = "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)]
      
      user = User.create!(first_name: first_name, last_name: last_name,
             email: email, password: password,
             password_confirmation: password,
             lat: lat, lng: lng, status: status,
             skype: skype, linkedin: linkedin,
             accepts_tandc: accepts_tandc,
             ip_address: ip_address)

      user.toggle!(:approved)
      user.toggle!(:completed)
    end

    User.all.each do |user|

      rand(51).times do
        user.cases.create!(
          :interviewer_id => 1 + rand(98),
          :date => randomDate(:year_range => 2, :year_latest => 0.5),
          :subject => Faker::Lorem.sentence(5),
          :source => Faker::Lorem.sentence(3),    
          :structure => 1 + rand(9),
          :structure_comment => Faker::Lorem.sentence(5),
          :analytical => 1 + rand(9),
          :analytical_comment => Faker::Lorem.sentence(5),
          :commercial => 1 + rand(9),
          :commercial_comment => Faker::Lorem.sentence(5),
          :conclusion => 1 + rand(9),
          :conclusion_comment => Faker::Lorem.sentence(5),
          :comment => Faker::Lorem.sentence(5),
          :notes => Faker::Lorem.sentence(5)
        )
      end

    end

    User.all.each do |user|
      
      # no longer needed as automatically created by after_create in user
      #user.notifications.create!(sender_id: 1, :ntype => "welcome")

      5.times do
        user.notifications.create!(:ntype => "message",
                                   :sender_id => rand(100), 
                                   :content => Faker::Lorem.sentence(5))
        ## created in case.rb
        # user.notifications.create!(:ntype => "feedback_new",
        #                            :sender_id => rand(1..100), 
        #                            :content => Faker::Lorem.sentence(5),
        #                            :event_date => randomDate(:year_range => 1, :year_latest => 0),
        #                            :case_id => rand(1000))

        user.notifications.create!(:ntype => "feedback_req",
                                   :sender_id => rand(100), 
                                   :content => Faker::Lorem.sentence(5),
                                   :event_date => randomDate(:year_range => 1, :year_latest => 0))
      end
    end

    Notification.all.each do |notification|

      if rand(2) == 1
        notification.read == true
      end

    end


    # Friendships
    # User.all.each do |user|

    #   15.times do |n|
    #     user.friendships.create!(friend_id: n)
    #   end

    # end

    # Friendship.all.each do |friendship|

    #   if rand(2) == 1
    #     friendship.pending == false
    #   end

    # end

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