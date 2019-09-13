FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    # Use the 'sequence' method in a factory to get a counter
    # of how many times a factory was used as an argument to its block
    # This can be especially useful when dealing with a column
    # that has a uniqueness validation
    sequence(:email) { |n| Faker::Internet.email.sub("@", "-#{n}@" )}
    password { "supersecret" }
  end
end
