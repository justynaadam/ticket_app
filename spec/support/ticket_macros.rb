module TicketMacros  

  def create_sample_categories
    main_categories = %w[event travel]
    main_categories.each { |main_category| Category.create!(text: main_category) }
    event_subcategories = %w[sport music cinema thetre]
    event_subcategories.each { |event_subcategory| Category.create!(text: event_subcategory, main_id: 1) }
    ticket_subcategories = %w[bus train plane]
    ticket_subcategories.each { |ticket_subcategory| Category.create!(text: ticket_subcategory, main_id: 2) }
  end
  def fillin_ticket_form(args)
    fill_in 'Title', with: args[:title]
    fill_in 'Content', with: args[:content]
    select(args[:ticket_type])
    fill_in 'Price', with: args[:price]
    fill_in 'Location', with: args[:location]
    select(args[:category], from: 'ticket_category_id')
    fill_in 'Name', with: args[:name]
    fill_in 'Phone', with: args[:phone]
  end
  def create_ticket_attributes(valid_type = 'invalid')
    create_sample_categories
    if valid_type == 'valid'
      valid_attr = {
        title: Faker::Lorem.characters(20),
        content: Faker::Lorem.sentence,
        price: 200,
        ticket_type: 'eTicket',
        location: Faker::GameOfThrones.city,
        category: Category.all.find(4).text,
        name: Faker::Name.name, 
        phone: Faker::PhoneNumber.subscriber_number(9).to_i
      }
    else
      invalid_attr = {
        title: nil,
        content: nil,
        price: nil,
        ticket_type: 'eTicket',
        location: nil,
        category: Category.all.find(4).text,
        name: nil, 
        phone: nil
      }
    end
  end
end