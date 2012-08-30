namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do

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

    admin.toggle!(:admin)

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