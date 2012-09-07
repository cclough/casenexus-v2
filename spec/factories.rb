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

    education1 "Eton"
    education2 "Oxford"
    education3 "Cambridge"

    experience1 "WHO"
    experience2 "Candesic"
    experience3 "Carter Press"

    education1_from Date.new(2012, 12, 1)
    education2_from Date.new(2012, 12, 1)
    education3_from Date.new(2012, 12, 1)
    education1_to Date.new(2012, 12, 1)
    education2_to Date.new(2012, 12, 1)
    education3_to Date.new(2012, 12, 1)

    experience1_from Date.new(2012, 12, 1)
    experience2_from Date.new(2012, 12, 1)
    experience3_from Date.new(2012, 12, 1)
    experience1_to Date.new(2012, 12, 1)
    experience2_to Date.new(2012, 12, 1)
    experience3_to Date.new(2012, 12, 1)

    # for when you want to test capabilty of an admin user
    # eg 'let(:admin) { FactoryGirl.create(:admin) }'
    factory :admin do
      admin true
    end

    factory :approved do
      approved true
    end

  end

end