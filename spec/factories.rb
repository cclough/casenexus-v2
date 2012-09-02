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
    
  end

end