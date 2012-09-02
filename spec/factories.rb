FactoryGirl.define do

  factory :user do
    
    first_name "Person"
    sequence(:last_name)  { |n| "#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    lat Random.rand(150..180)
    lng Random.rand(200..360)
    accepts_tandc true
    status "a" * 51

    # for when you want to test capabilty of an admin user
    # eg 'let(:admin) { FactoryGirl.create(:admin) }'
    factory :admin do
      admin true
    end

    factory :approved do
      approved true
    end

    # has_many association
    cases { FactoryGirl.create_list(:case, 2) }

  end

  
  factory :case do
    
    user_id 1
    interviewer_id 2
    date Date.new(2012, 3, 3)
    subject "Some Subject"
    source "Some Source"

    structure 5
    structure_comment "Structure Comment"
    analytical 9
    analytical_comment "Analytical Comment"
    commercial 10
    commercial_comment "Commercial Comment"
    conclusion 1
    conclusion_comment "Conclusion Comment"

    comment "Overall Comment"
    notes "Some Notes"

  end



end