main_categories = ['event', 'travel']
main_categories.each { |main_category| Category.create!(text: main_category) }
e_subcategories = ['sport', 'music', 'cinema', 'thetre']
e_subcategories.each { |e_subcategory| Category.create!(text: e_subcategory, main_id: 1) }
t_subcategories = ['bus', 'train', 'plane']
t_subcategories.each { |t_subcategory| Category.create!(text: t_subcategory, main_id: 2) }

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
  category_id = (3..9).to_a.shuffle[0]
  users.each do |user| 
    user.tickets.create!(title: title, content: content,
                         price: price, ticket_type: ticket_type,
                         location: location, category_id: category_id,
                         activated: true, activated_at: Time.zone.now)
  end
end
tickets = Ticket.all
ticket = Ticket.first
users = User.all
user = User.first
following = tickets[51..60]
followers = users[3..6]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(ticket) }
img = File.open(File.join(Rails.root, 'app/assets/images/rails.png'))
tickets = Ticket.all
tickets[1..50].each { |tic| tic.update_attribute(:picture, img) }