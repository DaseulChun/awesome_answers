# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Question.destroy_all
Answer.destroy_all
User.destroy_all

NUM_QUESTIONS = 200
NUM_USERS = 10
PASSWORD = "supersecret"

super_user = User.create(
  first_name: "Jon",
  last_name: "Snow",
  email: "js@winterfell.gov",
  password: PASSWORD,
  is_admin: true
)

NUM_USERS.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}.#{last_name.downcase}@example.com",
    password: PASSWORD
  )
end

users = User.all

NUM_QUESTIONS.times do
  created_at = Faker::Date.backward(days: 365 * 5)
  q = Question.create(
    title: Faker::Hacker.say_something_smart,
    body: Faker::ChuckNorris.fact,
    view_count: rand(100_000),
    created_at: created_at,
    updated_at: created_at,
    user: users.sample
  )

  if q.valid?
    q.answers = rand(0..10).times.map do
      Answer.new(body: Faker::GreekPhilosophers.quote, user: users.sample)
    end
  end
end

questions = Question.all
answers = Answer.all

puts Cowsay.say("Generated #{questions.count} questions", :frogs)
puts Cowsay.say("Generated #{answers.count} answers", :stegosaurus)
puts Cowsay.say("Generated #{users.count} users", :tux)
puts "Login with #{super_user.email} and password: #{PASSWORD}"