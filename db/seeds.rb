User.create!(name: 'Admin Name',
             phone: 123123,
             email: "example@foobar.org",
             password:    "foobar",
             admin: true)

99.times do |n|
  email = "example-#{n+1}@foobar.org"
  password = "password"
  name  = Faker::Name.name
  phone = Faker::Number.number(9)
  User.create!(name:  name,
               phone: phone,
               email: email,
               password: password,
               password_confirmation: password)
end
users = User.all
users.each { |user| user.confirm }

users = User.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.sentence(1)
  content = Faker::Lorem.sentence(10)
  price = Faker::Number.number(3)
  ticket_type = 'paper'
  location = Faker::GameOfThrones.city
  users.each { |user| user.tickets.create!(title: title, content: content, price: price, ticket_type: ticket_type, location: location) }
end