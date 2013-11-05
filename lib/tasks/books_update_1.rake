desc "Books Update 1 - 4th November 2013"

task :books_update_1 => :environment do
  puts "Running book update 1"
  Book.create!(btype: "guide", url: "http://www.caseinterviewsecrets.com/", thumb: "caseinterviewsecrets.jpg", title: "Case Interview Secrets", author: "Victor Cheng", author_url: "http://www.caseinterview.com/", desc: "A former McKinsey interviewer reveals how to get multiple job offers in consulting.")
  Book.create!(btype: "guide", url: "http://www.amazon.co.uk/Case-Point-Complete-Interview-Preparation/dp/0971015805", thumb: "caseinpoint.png", title: "Case in Point", author: "Marc P. Cosentino", author_url: "http://www.amazon.co.uk/Case-Point-Complete-Interview-Preparation/dp/0971015805", desc: "Cosentino demystifies the consulting case interview. He takes you inside a typical interview by exploring the various types of case questions and he shares with you the acclaimed Ivy Case System which will give you the confidence to answer even the most sophisticated cases.  The book includes over 40 strategy cases, a number of case starts exercises, several human capital cases, a section on marketing cases and 21 ways to cut costs.")
  Book.create!(btype: "guide", url: "http://www.amazon.co.uk/Ace-Your-Case-Consulting-Interviews/dp/1582072477/ref=sr_1_1?s=books&ie=UTF8&qid=1382824347&sr=1-1&keywords=wetfeet+consulting", thumb: "aceyourcase.png", title: "WetFeet", author: "Alan Weiss", author_url: "http://www.wetfeet.com/", desc: "This WetFeet Insider Guide provides tips on surviving the case interview; an explanation of the different case types, with classic examples of each; seven practice case questions you can use to practice applying your new skills; detailed examples of how to answer each type of case question, including sample interview scripts.")
  puts "Done."
end