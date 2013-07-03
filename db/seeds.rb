if %w(production development).include?(Rails.env) && User.count == 0
  
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

  puts "Creating Subjects"

  Subject.create!(name: "Agriculture and forestry")
  Subject.create!(name: "American studies")
  Subject.create!(name: "Anatomy and physiology")
  Subject.create!(name: "Anthropology")
  Subject.create!(name: "Archaeology")
  Subject.create!(name: "Architecture")
  Subject.create!(name: "Art and design")
  Subject.create!(name: "Biosciences")
  Subject.create!(name: "Building and town and country planning")
  Subject.create!(name: "Business and management studies")
  Subject.create!(name: "Chemical engineering")
  Subject.create!(name: "Chemistry")
  Subject.create!(name: "Civil engineering")
  Subject.create!(name: "Classics")
  Subject.create!(name: "Computer science and IT")
  Subject.create!(name: "Dentistry")
  Subject.create!(name: "Drama and dance")
  Subject.create!(name: "Earth and marine sciences")
  Subject.create!(name: "Economics")
  Subject.create!(name: "Education degree courses")
  Subject.create!(name: "Electronics and electrical engineering")
  Subject.create!(name: "Engineering general")
  Subject.create!(name: "English")
  Subject.create!(name: "Geography and environment studies")
  Subject.create!(name: "History and history of art")
  Subject.create!(name: "Law")
  Subject.create!(name: "Materials and mineral engineering")
  Subject.create!(name: "Mathematics")
  Subject.create!(name: "Mechanical engineering")
  Subject.create!(name: "Media studies, communications and librarianship")
  Subject.create!(name: "Medicine")
  Subject.create!(name: "Modern languages")
  Subject.create!(name: "Music")
  Subject.create!(name: "Nursing")
  Subject.create!(name: "Pharmacy and pharmacology")
  Subject.create!(name: "Philosophy")
  Subject.create!(name: "Physics")
  Subject.create!(name: "Politics")
  Subject.create!(name: "Psychology")
  Subject.create!(name: "Religious studies and theology")
  Subject.create!(name: "Social policy and administration")
  Subject.create!(name: "Social work")
  Subject.create!(name: "Sociology")
  Subject.create!(name: "Sports science")
  Subject.create!(name: "Tourism, transport and travel")
  Subject.create!(name: "Veterinary science")





  puts "Creating Languages"

  Language.create!(name: "English - UK", country_code: "GB")
  Language.create!(name: "English - US", country_code: "US")
  Language.create!(name: "French", country_code: "FR")


  puts "Creating Firms"

  Firm.create!(name: "Candesic")
  Firm.create!(name: "McKinsey & Company")
  Firm.create!(name: "BCG")
  Firm.create!(name: "Bain & Company")
  Firm.create!(name: "Roland Berger")
  Firm.create!(name: "OC&C")


  puts "Creating universities"

  University.create!(name: "University of Cambridge", image: "cambridge.png", domain: "cam.ac.uk")
  University.create!(name: "University of Oxford", image: "oxford.jpg", domain: "ox.ac.uk")
  University.create!(name: "Imperial College London", image: "imperial.png", domain: "imperial.ac.uk")
  University.create!(name: "London Business School", image: "lbs.png", domain: "london.edu")
  University.create!(name: "London School of Economics", image: "lse.png", domain: "lse.ac.uk")

  University.create!(name: "Harvard University", image: "harvard.png", domain: "harvard.edu")
  University.create!(name: "UC San Diego", image: "ucsd.png", domain: "ucsd.edu")
  University.create!(name: "Northwestern University", image: "northwestern.png", domain: "northwestern.edu")
  University.create!(name: "UC Berkeley", image: "ucberkeley.png", domain: "berkeley.edu")
  University.create!(name: "UPenn", image: "upenn.png", domain: "upenn.edu")
  University.create!(name: "Duke University", image: "duke.png", domain: "duke.edu")
  University.create!(name: "Stanford University", image: "stanford.png", domain: "stanford.edu")
  University.create!(name: "Columbia University", image: "columbia.png", domain: "columbia.edu")
  University.create!(name: "Cornell University", image: "cornell.png", domain: "cornell.edu")
  University.create!(name: "Brown University", image: "brown.png", domain: "brown.edu")
  University.create!(name: "Dartmouth College", image: "dartmouth.png", domain: "dartmouth.edu")
  University.create!(name: "Princeton University", image: "princeton.png", domain: "princeton.edu")
  University.create!(name: "Yale", image: "yale.png", domain: "yale.edu")

  puts "Creating library of sources"

  # Harvard
  Book.create!(btype: "case", url: "harvard_1.pdf", university_id: "6", chart_num: "0", difficulty: "1", title: "Retailer", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "A major retailer of clothing and household products has been experiencing sluggish growth and less than expected profits in the last few years. The CEO has hired you to help her increase the company's annual growth rate and ultimately its profitability.")
  Book.create!(btype: "case", url: "harvard_2.pdf", university_id: "6", chart_num: "0", difficulty: "1", title: "Butcher Shop", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "A fast food chain recently bought a bovine meat-processing outlet to supply it with fresh hamburgers and other meets. The shop process is: cows enter from one end of the shop, meat gets processed in the middle, and then the meat gets packaged and delivered at the other end.")
  Book.create!(btype: "case", url: "harvard_3.pdf", university_id: "6", chart_num: "0", difficulty: "1", title: "Juice Producer", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "A major producer of juice is in the business of processing and packaging fruit juice for retail outlets. Traditionally, the producer has packaged the juice in 18-ounce carton containers. Recently, in response to demand from the market, the producer purchased a machine that packages the juice in plastic gallons (36 ounces). Over the next couple of years, sales continued to grow on average of 20% per year. Yet, as sales continued to increase, profits steadily decreased. The owner cannot understand why. He hires you to help out.")
  Book.create!(btype: "case", url: "harvard_4.pdf", university_id: "6", chart_num: "0", difficulty: "1", title: "Chemical Manufacturer", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "A major chemical manufacturer produces a chemical product used to preserve foods in containers. Despite an increase in market share, the manufacturer has experienced a decline in profits. The CEO of the company is worried about this trend and hires you to investigate.")
  Book.create!(btype: "case", url: "harvard_5.pdf", university_id: "6", chart_num: "0", difficulty: "1", title: "VieTire", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "A tire manufacturer in Vietnam, VieTire, has been the only player in that market due to high tariffs on imports. They dominate the tire industry. As it stands, the tariff is 50% of the total cost to produce and ship a tire to Vietnam. Because of the forces of globalization and lower consumer prices, the Vietnamese government decided to lower the tariff by 5% a year for the next ten years. VieTire is very concerned about this change, as it will radically alter the landscape of the industry in Vietnam. They hire you to assess the situation and advise them on what steps to take.")
  Book.create!(btype: "case", url: "harvard_6.pdf", university_id: "6", chart_num: "0", difficulty: "1", title: "World View", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "A cable TV company from Canada, World View, had recently entered the US market in the northeast to expand its market share. World View saw this move as an opportunity to capture a large part of the US market (4MM consumers) in a market with very little competition. However, in the last couple of years, much to the surprise of management, World View has been unable to make a profit. You have been hired to figure out why and advise them on their next move.")
  Book.create!(btype: "case", url: "harvard_7.pdf", university_id: "6", chart_num: "0", difficulty: "1", title: "Le Seine", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "A French soft drink company, Le Seine, is looking to diversify its holdings by investing in a new fast food chain in the US. You are hired to determine whether they should pursue this path and, if so, how they should go about execution.")
  Book.create!(btype: "case", url: "harvard_8.pdf", university_id: "6", chart_num: "0", difficulty: "1", title: "Beer Brew", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "A major US beer company, Beer Brew, recently entered the UK market. Two years after entry, the company is still losing money. Despite a high per capita consumption of beer in the UK market, sales have been very disappointing. What explains this phenomenon?")
  Book.create!(btype: "case", url: "harvard_9.pdf", university_id: "6", chart_num: "0", difficulty: "1", title: "Wheeler Dealer", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "A major auto service chain, Wheeler Dealer, has enjoyed healthy returns on its 30-store operation for the past 10 years. However, management feels that the chain needs to expand, as the current geographical areas in which they are based have become saturated. For the past couple of years, they have aggressively pursued a growth strategy, opening an additional 15 stores. However, it seems that this approach has had negative returns. For the first time in over a decade, the chain's profits dropped into the negative zone. You were hired to figure out why.")
  Book.create!(btype: "case", url: "harvard_10.pdf", university_id: "6", chart_num: "0", difficulty: "2", title: "Travel Agency", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "A travel agency makes a 10% commission on all of its travel bookings. Their current profit before taxes is $1MM, while the industry average ranges from $2MM to $3.5MM. Why are they making less than the industry average?")
  Book.create!(btype: "case", url: "harvard_11.pdf", university_id: "6", chart_num: "0", difficulty: "2", title: "Hospital", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "Our client is a 350-bed hospital in a mid-size city. The organization has historically exhibited strong financial performance, and had a 1-3% operating gain each year for the last five years. However, they are projecting a $12 million operating loss this year, and expect this situation to worsen in the future. As a result, the CFO believes that they will be out of cash within five years. They have asked us to identify the source of this sudden downturn, and to come up with alternatives to restore them to a break-even position. They are one of the largest employers in the market, and will not consider layoffs as a possible solution.")
  Book.create!(btype: "case", url: "harvard_12.pdf", university_id: "6", chart_num: "0", difficulty: "2", title: "E-Grocery", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "The client is a grocery store chain that is considering whether or not they should enter the emerging Internet-based grocery shopping/delivery market in the Boston area. This regional chain is currently one of the leaders in the traditional grocery store market in northern New England.")
  Book.create!(btype: "case", url: "harvard_13.pdf", university_id: "6", chart_num: "0", difficulty: "2", title: "Formula Producer", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "The client is a manufacturer and distributor of infant formula. They sell their product nationwide, and are in the middle of the pack in terms of market share. They are currently trying to boost their market share while maintaining profitability.")
  Book.create!(btype: "case", url: "harvard_14.pdf", university_id: "6", chart_num: "0", difficulty: "2", title: "Pharmaceutical Company", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "Our client is the U.S. pharmaceutical division of a multi-national corporation. In about six months the division will receive FDA approval to launch an anti-depressant drug. Despite this apparent good news from the FDA, the U.S. division is not elated. It has concerns over the market potential for this drug and its ability to reach the key prescribers in this therapeutic category. We have been asked to help determine whether they should 1) launch alone, 2) co-market with a partner, or 3) sell, license or swap the drug.")
  Book.create!(btype: "case", url: "harvard_15.pdf", university_id: "6", chart_num: "0", difficulty: "2", title: "Scotch Manufacturer", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "We have been contacted by a large distilled spirits manufacturing and marketing company to develop a new strategy for one of their brands.")
  Book.create!(btype: "case", url: "harvard_16.pdf", university_id: "6", chart_num: "2", difficulty: "2", title: "Regional Jet Corporation", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "Regional Jet Corporation is a U.S. manufacturer of regional airplanes-airplanes with 100 seats or less. Its business consists of two types of aircraft: (1) jet engine, 80 to100-seat aircraft and (2) propeller, 20 to 30-seat aircraft. In fiscal year 1999, Regional Jet delivered 100 jet engine aircraft and 150 props. This represented a unit volume increase year-over-year of 10% and 5%, respectively, and revenues of $730 million and $225, million, respectively.")
  Book.create!(btype: "case", url: "harvard_17.pdf", university_id: "6", chart_num: "0", difficulty: "2", title: "British Times", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "The team has already had one meeting with the newspaper's online spin-off: BritishTimes.com. You are going to join the team for the second meeting, which will be held with only the CEO of the BritishTimes.com. Currently, their web site is nothing more than an online version of the newspaper, otherwise called brochureware.")
  Book.create!(btype: "case", url: "harvard_18.pdf", university_id: "6", chart_num: "0", difficulty: "3", title: "Children Clothes E-Retailer", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "It's a Friday afternoon. You've just accepted an offer to join our consulting company as a Senior Associate in the Business Strategy Competency. You've just called in to confirm your start time on your first day and find out you have an excellent opportunity to be the lead business strategist on a high profile project. We have partnered with a leading bricks-and-mortar children's apparel retailer to help them analyze, design, and build their Internet strategy. There will be a kick-off meeting for the project with the client (including the client's CEO) on Monday morning. The Principal/Engagement Leader on this project has asked you to lead a discussion about how the client should think about opportunities on the Internet. Right now, the client only has a marketing and informational presence on the web (a.k.a. \"brochureware\"). The Principal Engagement Leader wants the client to think about the range of opportunities and challenges the Internet presents and whether the client should invest aggressively in pursuing any initiatives.")
  Book.create!(btype: "case", url: "harvard_19.pdf", university_id: "6", chart_num: "0", difficulty: "3", title: "Consumer Products", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "It's Monday morning and as a new Principal/Engagement Leader, you've just gotten a call from a well known and respected French-based Consumer Products company. The company has offices in the US and has been selling through traditional channels throughout its history. It designs and manufactures plastic products like pens, pencils, disposable razors, etc. It's an old company that's been around for about 60 years and wants to take advantage of the Internet, starting with the US sales.")
  Book.create!(btype: "case", url: "harvard_20.pdf", university_id: "6", chart_num: "0", difficulty: "3", title: "The Video Store", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "Two business school classmates laud their entrepreneurship intentions and mock your interest in entering the management consulting industry. They decide that despite trends that indicate otherwise, what is needed is a video rental store closer to the HBS campus. ")
  Book.create!(btype: "case", url: "harvard_21.pdf", university_id: "6", chart_num: "0", difficulty: "3", title: "The English Church", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "Assume you are the new pastor of a rural English church in the late nineteenth century. Over the last three years, attendance has been declining. Your boss has just come to town to tell you that she is considering shutting down the church. You have two weeks to diagnose the problem and come us with possible solutions.")
  Book.create!(btype: "case", url: "harvard_22.pdf", university_id: "6", chart_num: "0", difficulty: "3", title: "HBS as a Business", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "You are Dean Clark. A wealthy benefactor has come to you with the news that she will give HBS $100 million. The grant is contingent, however, upon you using the money effectively. You have 1 week to propose to the benefactor where you would use the money before she will finalize the transfer.")
  Book.create!(btype: "case", url: "harvard_23.pdf", university_id: "6", chart_num: "0", difficulty: "3", title: "Fast Food Restaurant", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "Six months out of HBS, a frustrated classmate calls you to complain that the fast food burger joint that he bought has been steadily losing money for the last 3 months. He wants to know what you think he should do about it.")
  Book.create!(btype: "case", url: "harvard_24.pdf", university_id: "6", chart_num: "0", difficulty: "3", title: "Automobile Producer", source_title: "HBS Case Interview Guide", author: "Harvard Business School Management Consulting Club", author_url: "http://hbsmcc.com/", thumb: "hbs.png", desc: "The director of marketing at an automobile manufacturer suggests changing the current design, where two separate keys operate the ignition and the doors to a design where one key operates all lock mechanisms.")

  # Kellogg 2011
  Book.create!(btype: "case", url: "kellogg_2011_1.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "3", difficulty: "1", title: "Food Wholesaling Case", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client is an established food wholesaler that is trying to increase profitability. The situation is that our client is a wholesaler of a variety of different food items, and has a steady stream of business and is already profitable, but is looking to unlock more profitability from its existing lines of business\nHow can they can best increase profitability from their existing businesses?")
  Book.create!(btype: "case", url: "kellogg_2011_2.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "0", difficulty: "1", title: "GoNet Internet Service Provider", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, GoNet, is a US-based Internet Service Provider (ISP) that is considering entering the European market. They are currently the dominant player in the US with two revenue streams: a subscription access fee and by taking a percentage of all e-commerce transactions from subscribers.\nExamining the European market, GoNet has found that the market is highly fragmented and ripe for entry. You are going into a meeting with the CEO and have been asked to perform some quick \"back of the envelope\" calculations to determine the potential profitability of entering Europe.")
  Book.create!(btype: "case", url: "kellogg_2011_3.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "0", difficulty: "1", title: "Maine Apples", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client is a Korean conglomerate named Danut that has acquired a small Boston-based biotechnology firm. \n The biotech firm acquired has developed a chemical that helps control the ripening of produce. After testing, this chemical appears to work especially well with apples: it allows apple orchards to harvest earlier and it improves the overall quality of the harvest. \n Danut would like to know if they should attempt to commercialize this chemical.")
  Book.create!(btype: "case", url: "kellogg_2011_4.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "3", difficulty: "1", title: "Orrington Office Supplies (OOS)", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, OOS is a leading manufacturer of office products in 1992, with sales of $275M in 1991. They have strong brands, invest heavily in marketing / advertising, and have grown through prod. line extensions and four key acquisitions\nOOS is organized into 5 autonomous divisions, but shares manufacturing and marketing functions. Shared costs (45% of total) are allocated on a % of sales method. There are three plants running at a current capacity utilization is 50%\nAnalysts predict OOS is a potential acquisition target given its strong balance sheet but weakening earnings. They are publicly traded and have little long-term debt. As a potential investor, how would you improve its profitability.")
  Book.create!(btype: "case", url: "kellogg_2011_5.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "5", difficulty: "2", title: "Syzygy Supercomputers", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Syzygy Supercomputers is a large international fully-integrated computers and communications company with annual revenues of approximately $20 billion U.S.. In the past several years, the company has seen a steady decline in profits.\nThe CEO has asked us to look into this problem. How can Syzygy Supercomputers get back on track?")
  Book.create!(btype: "case", url: "kellogg_2011_6.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "0", difficulty: "2", title: "Winter Olympics Bidding", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client is a major US television network that is trying to figure out how much to bid for the 2018 Winter Olympics and has brought you into to help us figure out the right bid. The Winter Olympics are a huge deal and will require a significant amount of capital to secure the rights. Before our network bids on the Winter Olympics, we want to make sure that we have considered all the right things.")
  Book.create!(btype: "case", url: "kellogg_2011_7.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "2", title: "Rotisserie Ranch", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client is Rotisserie Ranch, a poultry farming company that specializes in growing chickens for rotisserie roasting. Its main line customer segment is comprised of large grocery chains, who buy its chickens to fresh roast in the meat departments of their grocery stores. Market research has revealed to Rotisserie Ranch that more and more consumers have begun buying flavored rotisserie chickens recently.")
  Book.create!(btype: "case", url: "kellogg_2011_8.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "0", difficulty: "2", title: "Tarrant Fixtures", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, Tarrant Fixtures, is a low-intensity manufacturing company that produces display fixtures for retail clients. The company's financial performance has deteriorated in each of the last three years. Specifically, they are concerned with the company's falling Return on Investment (ROI).\nThe CEO has asked us to look into this problem. How can Tarrant Fixtures get back on track?")
  Book.create!(btype: "case", url: "kellogg_2011_9.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "0", difficulty: "2", title: "Vindaloo Corporation", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, Vindaloo Corporation, is a small biotechnology company that has developed a new seed for sugar beets, which produces twice as much sugar as the seeds that are currently in use. They now want to sell the company, and wonder how much it is worth.")
  Book.create!(btype: "case", url: "kellogg_2011_10.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "0", difficulty: "2", title: "Zephyr Beverages", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, Zephyr Beverages, is a division of a large consumer products company. The division produces fruit juices in three forms, all under the Zephyr name: chilled, juice boxes, and frozen concentrate. Zephyr had sales of $600 million last year, about 3% of the company's overall sales of $20 billion.\nThe chilled segment represents $120 million in sales per year. While juice boxes and frozen concentrate have been consistently profitable, chilled juices are only breaking even in good quarters and are losing money in bad quarters. Zephyr has received a proposal from upper management to sell the chilled juices business. We need to help them decide whether or not this is a good idea.")
  Book.create!(btype: "case", url: "kellogg_2011_11.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "2", title: "A+ Airline Co.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client is A+Airline Co., the third largest airline in the United States by passengers carried. This week, we have been flying on our primary competitor, Gamma airline, and we noticed something interesting; they stopped accepting cash for in-flight food and beverage services and they now only accept major credit cards.\nThe CEO of A+Airline Co. wants to know, why did Gamma Airline switch from a Cash & Card system to a credit card only system, and should we follow them?")
  Book.create!(btype: "case", url: "kellogg_2011_12.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "3", difficulty: "2", title: "Bell Computer Inc.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, Bell Computer Inc., is the second largest PC manufacturer, by unit sales, in the United States. Over the past 5 years, Bell has been gaining market share and growing revenue, but at the same time, their net income is eroding.\nThe founder of Bell has returned to the company and taken over as CEO. He has hired us to determine:\n- Why have our profit margins declined?\n- What can we do to improve our profitability and reach our \"Full Potential\"?")
  Book.create!(btype: "case", url: "kellogg_2011_13.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "2", title: "Arbor Housing", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, Arbor Housing, is a leading provider of short term and temporary corporate housing. Profits have remained steady the past few years, and Arbor was recently purchased by a private equity firm that has brought in new management. The new CEO has been charged with increasing sales in order to meet managements growth targets for the next few years.\nWhat can Arbor Housing do to increase revenues, while remaining profitable?")
  Book.create!(btype: "case", url: "kellogg_2011_14.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "2", title: "Shermer Pharma", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, Shermer Pharma , is a venture backed start-up Pharmaceutical company. Over the past 15 years, Shermer has been developing a molecule that has been approved by the FDA to cure Alzheimer's with 90% efficacy.\nShermer's owners have hired us to determine:\n - How should we sell our product?\n - Is our product going to be profitable?")
  Book.create!(btype: "case", url: "kellogg_2011_15.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "0", difficulty: "2", title: "Hospitality Co", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client owns a large hotel chain and is thinking about investing in an add-on for a waterpark on one of its properties. This has been tested in some places and has a lot of potential benefits: family friendly, year-round availability, and potential to bring in new clientele. They have done a lot of work surveying their chain and believe that they have found the right hotel to experiment with a waterpark add-on. Currently, this hotel has a lot of business travelers, but our client believes it would also be attractive for families.\n Our client is nervous about the capital required to build the add-on and wants to make sure that they are making the right investment. That's why we brought you on board. What do you think?")
  Book.create!(btype: "case", url: "kellogg_2011_16.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "1", difficulty: "2", title: "Rock Energy", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Rock Energy, an Oil & Gas company, is evaluating the purchase of one of three oil fields in Latin America. After purchasing the rights to extract oil from one of these fields, Rock Energy will outsource the drilling activity. You have been brought in to identify the best investment for Rock Energy.\nHow would you evaluate the three oil fields, and which oil field should Rock Energy purchase?")
  Book.create!(btype: "case", url: "kellogg_2011_17.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "2", title: "Orange Retailer Co.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Orange Retailer Co. (ORC) manufactures, import/exports and distributes high-end world known brands and conservative/traditional apparel brands in several countries in Latin America. ORC is considering entering a new country in Latin America, and you have been hired to determine whether they should enter this new market or not.")
  Book.create!(btype: "case", url: "kellogg_2011_18.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "3", difficulty: "2", title: "Vitality Insurance, Inc.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, Vitality Insurance, is a leading provider of supplemental insurance products in the United States.\nVitality agents partner with companies to offer their employees optional, supplemental insurance for such conditions as life, cancer, etc.\nVitality has undergone fairly steady growth in the past two years, but they suspect that some of their costs may be out of whack. Is this indeed true, and, if so, what should they do about it?")
  Book.create!(btype: "case", url: "kellogg_2011_19.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "2", title: "Chic Cosmetology University", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client is a for-profit, specialty college named Chic Cosmetology University (CCU). Founded in 2005, CCU is a program for high school graduates seeking their professional cosmetology license. CCU is currently the market leader for cosmetology education with campuses in ten major metropolitan areas in the US.\nCCU has capital to invest in a new campus and is considering Chicagoland as a location - should they do it?")
  Book.create!(btype: "case", url: "kellogg_2011_20.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "2", title: "DigiBooks Inc.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, DigiBooks, is a manufacturer and seller of electronic book readers . DigiBooks also distributes e-books for the e-reader through their website. The reader is only compatible with books sold through the DigiBooks site.\nDigiBooks is planning the launch of its e-book readers in a country where no e-book readers are currently sold. Only 1% of the population has ever used a e-book reader, though 50% is aware of the concept. The Chief Marketing Officer of DigiBooks has come to you to help determine:\nHow should DigiBooks launch and market the e-reader product in this new country?")
  Book.create!(btype: "case", url: "kellogg_2011_21.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "2", title: "After School Programming", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "It is 2003, and our client offers after school programming focused on supporting at-risk youth through high school, enabling them to enter and succeed in college.\nThe client is trying to identify the best approach to meet its growth target. The client's goals for expansion are to most efficiently serve students at 7 new sites, while raising their national profile. We have been hired to help them vet potential sites to maximize their social and financial impact.")
  Book.create!(btype: "case", url: "kellogg_2011_22.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "2", title: "Dark Sky Co.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, Dark Sky, is a small manufacturer of unmanned (i.e. remotely piloted) data collection aircraft. Dark Sky produces the Assessor, an aircraft originally designed for unmanned weather exploration. In 2003, the United States military began purchasing Assessors for use in Intelligence, Surveillance and Reconnaissance (ISR) missions. The Assessor is profitable, but sales have stagnated and the client wishes to grow.\nWhat are some steps Dark Sky could take to achieve growth?")
  Book.create!(btype: "case", url: "kellogg_2011_23.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "3", title: "Health Coaches", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client is a large national health care payer (health insurance company, think Aetna) exploring the launch of a new disease management (\"DM\") program to better serve its 5 million members. The idea is to hire and train a team of \"Health Coaches\" to specialize in a single disease area (e.g., heart disease, diabetes, etc). Each Coach will manage a portfolio of patients to reduce the costs of overall health expenditures (e.g., reminders to take drugs, provide limited medical advice, suggested diet, etc). Studies show that once a month contact with each patient reduces health spending by 5%, on average.\nShould our client launch the program? If so, what steps should it take?")
  Book.create!(btype: "case", url: "kellogg_2011_24.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "3", difficulty: "3", title: "Ocular Co.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "The first contact lenses were made of glass and appeared in the early 20th century, but contacts have come a long way since then - it is estimated that there are more than 100 million contact lens wearers around the world today. Ocular Co. currently commands 40% of the Irish contact lens market with its franchise of soft-contact disposable lenses that are disposed of weekly. In addition, Ocular has been considering the launch of Ireland's FIRST daily disposable contact lens after it received a favorable regulatory review, but wants to know if it should launch.\nWhat are the key issues Ocular should consider when considering the launch of this product?\nWill this be a profitable venture? Should Ocular Co launch?")
  Book.create!(btype: "case", url: "kellogg_2011_25.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "0", difficulty: "3", title: "Wine & Co.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Wine & Co. is a niche wine manufacturer in the San Francisco Bay area. Wine & Co. recently acquired 12 acres of land outside San Francisco. The company wants to investigate opportunities to best use the land and needs a recommendation from you.")
  Book.create!(btype: "case", url: "kellogg_2011_26.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "3", difficulty: "3", title: "Healthy Foods Co.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client is Healthy Foods Co, a wholesaler serving a variety of clients with Food products. The client is profitable but they want you to help them find revenue growth opportunities from their current business.\nHow can we help Healthy Foods Co. drive their revenue growth?")
  Book.create!(btype: "case", url: "kellogg_2011_27.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "3", difficulty: "3", title: "High Q Plastics", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client, High Q Plastics, is an automotive parts supplier in the U.S. They primarily manufacture and sell plastic injection-molded parts, such as grills, door handles, decorative trim etc., to automotive customers.\nThe client has two primary revenue sources: large automotive OEMs, and aftermarket. The client has recently seen declining profits, primarily due to increased price competition from new overseas competitors in China. Annual profits have declined from $50M to $20M over the past few years.\nWhat is the reason behind declining profitability? How can High Q improve profits? Can they reach $100M in profits by 2014?")
  Book.create!(btype: "case", url: "kellogg_2011_28.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "2", difficulty: "3", title: "Salty Sole Shoe Co.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Your client is a large retail-focused private equity firm that owns Salty Sole, a leading designer of junior women's footwear, primarily targeting the 14 - 22 year old age group. Salty Sole was purchased last year by the private equity firm expecting to realize substantial profits upon sale in 2012 by increasing the company's EBITDA. The situation, however, is that due to a current recession, annual profit has only grown modestly post the acquisition and is not on track to generate the double-digit returns that the private equity firm originally anticipated. \nHow can the company increase profitability and achieve the private equity firm's return on investment objectives?")
  Book.create!(btype: "case", url: "kellogg_2011_29.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "3", difficulty: "3", title: "Plastic World", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client is a private equity firm interested in PlasticWorld, a plastic packaging manufacturer. \nPlasticWorld's owners are requesting $25M. The offer is final. Should our client buy?")
  Book.create!(btype: "case", url: "kellogg_2011_30.pdf", thumb: "kellogg.png", university_id: "8", chart_num: "1", difficulty: "3", title: "Zoo Co.", source_title: "Case Book, 2011 Edition", author: "Kellogg Consulting Club", author_url: "http://kellogg.campusgroups.com/consulting/home/", desc: "Our client is a zoo that is thinking about acquiring a famous zebra from an African preserve.\nIt's a huge investment, but they believe the new zebra would be a great contribution to their animal community. You have been engaged to help decide whether this is a good idea. What would you consider when trying to help your client make this decision?")

  # Wharton 2009
  Book.create!(btype: "case", url: "wharton_2010_1.pdf", thumb: "wharton.png", university_id: "8", chart_num: "0", difficulty: "2", title: "Mexico City Airport Taxi Services", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "The authorities of the Mexico City airport have decided to issue 2,500 new taxi permits for $1,000 each. These permits authorize a taxi to service arriving passengers. Your client has a taxi fleet in the city but does not service the airport. He has excess capacity (meaning he has cars and drivers available). He has asked you to determine if he should buy those new permits. If so, how many should he buy?")
  Book.create!(btype: "case", url: "wharton_2010_2.pdf", thumb: "wharton.png", university_id: "8", chart_num: "0", difficulty: "2", title: "Franchising Gyms", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "Your client is a gym franchisor. The client focuses on small gyms (approximately 3000 square feet) with standard fitness equipment, but no classes or lockers. The gyms are typically located in local strip malls. They are open 24 hours per day; members enter the gym via an access card. Staffing at the gym is minimal to none (depends on each individual franchisee).\nThis business is growing very rapidly. However, there is now a new competitor offering a similar franchising opportunity. To make our client's franchising opportunity more attractive, our client would like your input on how the profitability of its franchises can be improved.")
  Book.create!(btype: "case", url: "wharton_2010_3.pdf", thumb: "wharton.png", university_id: "8", chart_num: "0", difficulty: "2", title: "Greeting Card Manufacturer", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "A greeting card manufacturer has experienced decreased profit. The CEO has asked you to figure out why.")
  Book.create!(btype: "case", url: "wharton_2010_4.pdf", thumb: "wharton.png", university_id: "8", chart_num: "2", difficulty: "2", title: "UK Asset Manager", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "Our client is a private equity firm that is looking at a potential acquisition target. The target is a UK asset management firm that has seen a 33% drop in AUM in the past 18 months. Outside of a valuation analysis of the target (assume this has been done by the client), we need to determine whether or not this is a good acquisition.")
  Book.create!(btype: "case", url: "wharton_2010_5.pdf", thumb: "wharton.png", university_id: "8", chart_num: "1", difficulty: "2", title: "Mighty Mining Company", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "Your client is a global mining company with a location in South Africa. This particular location is performing below average financially. McKinsey has been hired to identify the problem and make recommendations to address it. What would you do first to approach this problem?")
  Book.create!(btype: "case", url: "wharton_2010_6.pdf", thumb: "wharton.png", university_id: "8", chart_num: "0", difficulty: "2", title: "The Reel Deal", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "A movie studio client has an extensive library of hit movies from prior years. As part of your effort to find new sources of profit for the company, you are to assess the viability of digitizing the movie reels and making them available online for a fee.")
  Book.create!(btype: "case", url: "wharton_2010_7.pdf", thumb: "wharton.png", university_id: "8", chart_num: "0", difficulty: "2", title: "Publishing Company", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "Your client is Putter, a company that publishes romance novels that they sell to bookstores. Typically, Putter reimburses its customers at the end of the year for any unsold inventory. Now, one of Putter's customers, a retail bookstore, has come to it with an offer for a deal. In return for a 10% discount on wholesale prices, the bookstore will no longer send back any books at the end of the year. Should Putter do the deal?")
  Book.create!(btype: "case", url: "wharton_2010_8.pdf", thumb: "wharton.png", university_id: "8", chart_num: "0", difficulty: "3", title: "Retirement Apartment Complexes", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "The client owns and operates 25 retirement apartment complexes for the 55-75 year old demographic in the south-east and south-west states of FL, CA, NM and AZ. By and large the apartment complexes have a similar design and amenities. Should the client company's CEO consider expanding to other Northern cities or continue to focus on the South?")
  Book.create!(btype: "case", url: "wharton_2010_9.pdf", thumb: "wharton.png", university_id: "8", chart_num: "1", difficulty: "3", title: "Big Yellow Bus", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "Your client is a private equity fund considering the acquisition of Big Yellow Bus Co, one of the leading manufacturers of school buses in the US. The client has engaged Bain to help determine whether or not to proceed with the investment.")
  Book.create!(btype: "case", url: "wharton_2010_10.pdf", thumb: "wharton.png", university_id: "8", chart_num: "0", difficulty: "3", title: "Car Company", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "Frank is 65 years old, and for his entire working career, has owned a manufacturing company which manufactures unibody car frames. He has always had one contract with one vehicle OEM, however this year that OEM has decided not to renew its contract. What should Frank do?")
  Book.create!(btype: "case", url: "wharton_2010_11.pdf", thumb: "wharton.png", university_id: "8", chart_num: "0", difficulty: "3", title: "Blood Bank", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "Our client is a blood bank that has operations spanning four states. They operate many sites from which their staff go out to different locations (e.g., schools and offices) in order to collect blood samples. Next, the blood is transported to centralized processing centers for testing, treatment, etc. (there is one processing center per state). Finally, the blood is transported from the testing centers to the hospitals that ultimately use the blood. The blood bank faces competition from other blood collection organizations. Only 80% of hospital demand for blood is currently being met. As a result, hospitals often have to share blood by transporting it between different hospitals, which is costly. There are no substitutes for human blood (synthetic substances or animal blood).\nTheir profitability has been slowly declining for some time and they are worried because new regulations are coming out that will require them to invest in an expensive new technology. The CEO wants to investigate potential areas to look at in order to improve profitability and wants to know how to prioritize among them.")
  Book.create!(btype: "case", url: "wharton_2010_12.pdf", thumb: "wharton.png", university_id: "8", chart_num: "2", difficulty: "3", title: "EasyNav", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "EasyNAV is a multi-national third-party fund accounting company based in New York. Asset managers, such as Fidelity or other smaller investment shops, often outsource the calculation of their daily fund prices to third-parties such as EasyNAV. These fund prices, called Net Asset Values, or \"NAVs,\" represent the per-share price of the fund, which then becomes published to the general public, e.g., in the Wall Street Journal. Given the high financial stakes, asset managers require EasyNAV to be both highly accurate and timely in their NAV calculations. This is still a highly manual process due to the number of data sources required to collect this information and inconsistency in data formats delivered to EasyNAV. Although business growth has been strong over the last five years, EasyNAV has seen its costs rising more quickly than its revenues. At the current trajectory, costs will exceed revenues within the next decade, and something must be done. What are the causes of EasyNAV's rising costs, and what can be done to reduce them?")
  Book.create!(btype: "case", url: "wharton_2010_13.pdf", thumb: "wharton.png", university_id: "8", chart_num: "0", difficulty: "3", title: "Manny's Manufacturing", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "Manny's Manufacturing is a U.S. based company that produces a consumer packaged good. It currently has manufacturing facilities in the U.S. and an idle plant in South America. The executive team at Manny's Manufacturing is trying to determine the health of its business and whether to use the South American plant.")
  Book.create!(btype: "case", url: "wharton_2010_14.pdf", thumb: "wharton.png", university_id: "8", chart_num: "0", difficulty: "3", title: "Zenith Hotel", source_title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/", desc: "Zenith Hotel is a global hotel chain with 50 hotels in 20 countries. The company is evaluating the construction of a new hotel in the Bahamas. Zenith has come to us asking whether it should and can move forward with the project.")

  # Guides

  Book.create!(btype: "guide", url: "guide_wharton_2009-2010.pdf", thumb: "wharton.png", university_id: "10", title: "Wharton Consulting Club Casebook 2009-2010", author: "Wharton Consulting Club", author_url: "http://www.wharton.upenn.edu/")
  Book.create!(btype: "guide", url: "guide_fuqua_2010-2011.pdf", thumb: "fuqua.png", university_id: "8", title: "Fuqua Casebook 2010-2011", author: "The Fuqua School of Business, Duke", author_url: "http://www.fuqua.duke.edu/")
  
  # Links

  Book.create!(btype: "link", title: "Introduction to Case Interviews", source_title: "CaseInterview.com", author: "Victor Cheng", author_url: "http://www.caseinterview.com/", desc: "The best introduction out there to case interviews. 6 hours of Videos of a presentation at Harvard Business School - 12 videos", url: "http://www.youtube.com/watch?v=fBwUxnTpTBo&list=UU-YKX7L2GNNA-IHrhMpwzWA&index=13", thumb: "caseinterview.png")
  Book.create!(btype: "link", title: "Look Over My Shoulder Programme", source_title: "CaseInterview.com", author: "Victor Cheng", author_url: "http://www.caseinterview.com/", desc: "Series of Audio Tapes", url: "http://www.caseinterview.com/look-over-my-shoulder", thumb: "caseinterview.png")



  # Channels

  Country.all.each do |country|

    Channel.create!(country_id: country.id)

    puts "Channel created for country #{country.name}"

  end

  University.all.each do |university|

    Channel.create!(university_id: university.id)

    puts "Channel created for university #{university.name}"

  end







  puts "Creating christian's user"

  admin = User.new(
      first_name: "Christian",
      last_name: "Clough",
      email: "casenexus@cam.ac.uk",
      password: "testing",
      password_confirmation: "testing",
      lat: 51.5100,
      lng: -0.1344,
      invitation_code: 'BYPASS_CASENEXUS_INV',

      language_ids: 1,

      subject_id: 5,
      degree_level: 0,
      
      cases_external: 24,

      skype: "christianclough",

      confirm_tac: "1",

      time_zone: "UTC",

      ip_address: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)])
  admin.completed = true
  admin.admin = true
  admin.save!
  admin.confirm!

  puts "Creating alastair's user"

  admin = User.new(
      first_name: "Alastair",
      last_name: "Willey",
      email: "alastair.willey@imperial.ac.uk",
      password: "design",
      password_confirmation: "design",
      lat: 51.90128232665856,
      lng: -0.5421188764572144,
      invitation_code: 'BYPASS_CASENEXUS_INV',

      language_ids: 1,

      subject_id: 2,
      degree_level: 1,

      cases_external: 12,

      skype: "cloughrobin",

      confirm_tac: "1",

      time_zone: "Lisbon",

      ip_address: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)])
  admin.completed = true
  admin.admin = true
  admin.save!
  admin.confirm!

  puts "Creating robin's user"

  admin = User.new(
      first_name: "Robin",
      last_name: "Clough",
      email: "robin.clough@rady.ucsd.edu",
      password: "testing",
      password_confirmation: "testing",
      lat: 32.869627,
      lng: -117.221015,
      invitation_code: 'BYPASS_CASENEXUS_INV',

      language_ids: 1,

      subject_id: 8,
      degree_level: 1,

      cases_external: 14,

      skype: "cloughrobin",

      confirm_tac: "1",

      time_zone: "Fiji",

      ip_address: "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)])

  admin.completed = true
  admin.admin = true
  admin.save!
  admin.confirm!


  puts "Creating Christian's Friendships"

  Friendship.connect(User.find(1), User.find(2))
  Friendship.connect(User.find(1), User.find(3))


end

if Rails.env == 'development'

  ####### PRIVATE FUNCTIONS #######

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

  def rand_time(from, to=Time.now)
    Time.at(rand_in_range(from.to_f, to.to_f))
  end

  def rand_in_range(from, to)
    rand * (to - from) + from
  end

  ################################



  30.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name

    university_rand = 1 + rand(10)
    email = "example#{n+1}@" + University.find(university_rand).domain

    password = "password"
    lat = -90 + rand(180)
    lng = -180 + rand(360)
    skype = "skpye"
    language_ids = 1

    subject_id = rand(15)
    degree_level = rand(1)

    last_online_at = rand_time(2.days.ago)
    cases_external = 10

    confirm_tac = "1"

    time_zone = ["Lisbon", "UTC", "Atlantic Time (Canada)", "Bogota", "Mid-Atlantic", "Fiji"].sample

    ip_address = "%d.%d.%d.%d" % [rand(255) + 1, rand(256), rand(256), rand(256)]

    user = User.new(first_name: first_name, last_name: last_name,
                    email: email, password: password,
                    password_confirmation: password,
                    lat: lat, lng: lng,
                    language_ids: language_ids,
                    skype: skype,
                    subject_id: subject_id,
                    degree_level: degree_level,
                    last_online_at: last_online_at,
                    cases_external: cases_external,
                    confirm_tac: confirm_tac,
                    ip_address: ip_address,
                    time_zone: time_zone,
                    invitation_code: 'BYPASS_CASENEXUS_INV')

    user.completed = true
    user.save!
    user.confirm!

    puts "User #{user.name} created"

    puts "Creating #{user.name}'s Friendships"

    Friendship.connect(user, User.find(1))
    Friendship.connect(user, User.find(2))
    Friendship.connect(user, User.find(3))

  end





  # Languages
  #User.all.each do |user|

    5.times do

      user = User.find(rand(9) + 1)

      language_id = 3
      lang = Language.find(language_id)
      
      # check if exists already though!
      if !user.languages.include? lang
        user.languages << lang
        puts "Language association created for user #{user.name}"
      end

    end

  #end




  # Firms
  User.all.each do |user|
    7.times do

      firm_id = rand(5) + 1
      firm = Firm.find(firm_id)
      
      # check if exists already though!
      if !user.firms.include? firm
        user.firms << firm
        puts "Firm association created for user #{user.name}"
      end

    end
  end





  # Posts
  User.all.each do |user|
    #user = User.find(1)

    1.times do
      channel_id = 1 + rand(5)
      user.posts.create!(
          content: Faker::Lorem.sentence(40),
          channel_id: channel_id
      )
      puts "Post created for user #{user.name}"
    end

  end





  User.all.each do |user|
    #user = User.find(1)

    11.times do
      interviewer_id = 1 + rand(1)
      next if interviewer_id.to_i == user.id.to_i
      user.cases.create!(
          interviewer_id: interviewer_id,
          book_id: 1 + rand(30),
          subject: Faker::Lorem.sentence(5),
          source: Faker::Lorem.sentence(3),

          recommendation1: Faker::Lorem.sentence(10),
          recommendation2: Faker::Lorem.sentence(10),
          recommendation3: Faker::Lorem.sentence(10),

          structure_comment: Faker::Lorem.sentence(30),
          businessanalytics_comment: Faker::Lorem.sentence(30),
          interpersonal_comment: Faker::Lorem.sentence(30),

          quantitativebasics: 1 + rand(4),
          problemsolving: 1 + rand(4),
          prioritisation: 1 + rand(4),
          sanitychecking: 1 + rand(4),

          rapport: 1 + rand(4),
          articulation: 1 + rand(4),
          concision: 1 + rand(4),
          askingforinformation: 1 + rand(4),

          approachupfront: 1 + rand(4),
          stickingtostructure: 1 + rand(4),
          announceschangedstructure: 1 + rand(4),
          pushingtoconclusion: 1 + rand(4)
      )
      puts "Case created for user #{user.name}"
    end

  end

  
  #User.all.each do |user|
  user = User.find(1)

    2.times do
      sender_id = rand(2) + 1
      next if user.id.to_s == sender_id.to_s
      user.notifications.create!(ntype: "message",
                                 sender_id: sender_id,
                                 content: Faker::Lorem.sentence(5))

      puts "Message Notifications created for user #{user.name}"
    end

  #end


  Notification.all.each do |notification|
    if rand(2) == 1
      notification.read!
      puts "Notification marked as read"
    end
  end




  user = User.find(1)

    5.times do
      partner_id = rand(2) + 1
      user.events.create!(partner_id: partner_id,
                          book_id_user: 1,
                          book_id_partner: 1,
                          datetime: random_date(year_range: 2, year_latest: 0.5))

      puts "Events created for user #{user.name}"
    end






end

