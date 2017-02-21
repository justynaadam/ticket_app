User.create!(name: 'Admin Name',
             location: 'Admin location',
             phone: 123123,
             email: "example@foobar.org",
             password:    "foobar",
             admin: true)

99.times do |n|
  email = "example-#{n+1}@foobar.org"
  password = "password"
  name  = Faker::Name.name
  location = Faker::GameOfThrones.city
  phone = Faker::Number.number(9)
  User.create!(name:  name,
               location: location,
               phone: phone,
               email: email,
               password: password,
               password_confirmation: password)
end
