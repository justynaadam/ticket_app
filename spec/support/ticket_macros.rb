module TicketMacros  

  def create_sample_categories
    main_categories = %w[event travel]
    main_categories.each { |main_category| Category.create!(text: main_category) }
    e_subcategories = %w[sport music cinema thetre]
    e_subcategories.each { |e_subcategory| Category.create!(text: e_subcategory, main_id: 1) }
    t_subcategories = %w[bus train plane]
    t_subcategories.each { |t_subcategory| Category.create!(text: t_subcategory, main_id: 2) }
  end
  def fillin_edit_ticket_form(args)
    fill_in 'Title', with: args[:title]
    fill_in 'Content', with: args[:content]
    select(args[:ticket_type])
    fill_in 'Price', with: args[:price]
    fill_in 'Location', with: args[:location]
    select(args[:category], from: 'ticket_category_id')
    fill_in 'Name', with: args[:name]
    fill_in 'Phone', with: args[:phone]
  end
end