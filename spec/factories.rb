FactoryGirl.define do
  factory :user do
    
    first_name "Person"
    sequence(:last_name)  { |n| "#{n}" }

    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    lat 50
    lng 0
    accepts_tandc true
    status "a" * 51

    factory :admin do
      admin true
    end
  end

end