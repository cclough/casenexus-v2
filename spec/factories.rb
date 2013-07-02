FactoryGirl.define do

  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    lat Random.rand(150..180)
    lng Random.rand(200..360)
    confirm_tac true
    status "a" * 51

    factory :admin do
      admin true
    end

    factory :status_approved do
      status_approved true
    end
  end

  factory :case do
    date { Date.today - 2.days }

    subject Faker::Lorem.sentence(5)
    source Faker::Lorem.sentence(3)

    recommendation1 Faker::Lorem.sentence(10)
    recommendation2 Faker::Lorem.sentence(10)
    recommendation3 Faker::Lorem.sentence(10)

    structure_comment Faker::Lorem.sentence(30)
    businessanalytics_comment Faker::Lorem.sentence(30)
    interpersonal_comment Faker::Lorem.sentence(30)

    quantitativebasics { 1 + rand(10) }
    problemsolving { 1 + rand(10) }
    prioritisation { 1 + rand(10) }
    sanitychecking { 1 + rand(10) }

    rapport { 1 + rand(10) }
    articulation { 1 + rand(10) }
    concision { 1 + rand(10) }
    askingforinformation { 1 + rand(10) }

    approachupfront { 1 + rand(10) }
    stickingtostructure { 1 + rand(10) }
    announceschangedstructure { 1 + rand(10) }
    pushingtoconclusion { 1 + rand(10) }

    association :user, factory: :user
    association :interviewer, factory: :user
  end

  factory :notification do
    read false
    association :user, factory: :user
    association :sender, factory: :user

    factory :welcome_notification do
      ntype "welcome"
      association :sender, factory: :admin
    end

    factory :message_notification do
      ntype "message"
      content Faker::Lorem.paragraph
    end

    factory :feedback_notification do
      ntype "feedback"
      content Faker::Lorem.sentence
      association :notificable, factory: :case
    end

    factory :friendship_request_notification do
      ntype "friendship_req"
    end

    factory :friendship_approval_notification do
      ntype "friendship_app"
    end
  end
end