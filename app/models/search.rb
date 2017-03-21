class Search < ApplicationRecord
  belongs_to :user, optional: true

  before_create :destroy_all_searches

  def destroy_all_searches
    Search.where(user_id: nil).destroy_all
  end

  def tickets
    @tickets ||= find_tickets
  end
  
  def update_time
    update_attribute(:time, Time.zone.now)
  end

  def new_tickets
    new_tickets = tickets.where('activated_at > ?', time)
    new_tickets
  end


  def find_tickets
    tickets = Ticket.activated
    tickets = tickets.where.not(picture: nil)                                    if with_picture?
    tickets = tickets.where("tickets.user_id = ?", searched_user)                if searched_user.present?
    tickets = tickets.where("tickets.title LIKE ? ", "%#{keywords}%")            if keywords.present?
    tickets = tickets.where("tickets.content LIKE ? ", "%#{keywords}%")          if (in_content? && keywords.present?)
    tickets = tickets.where("tickets.location LIKE ?", "%#{location_keywords}%") if location_keywords.present?
    tickets = tickets.where("tickets.price <= ?", maximum_price)                 if maximum_price.present?
    tickets = tickets.where("tickets.price >= ?", minimum_price)                 if minimum_price.present?
    tickets = tickets.where("tickets.ticket_type = ?", type_of_ticket)           if type_of_ticket.present?
    if category_id.present?
      category = Category.find(category_id)
        if category.main?
          sub_ids = category.subcategories.ids
          tickets = tickets.where("tickets.category_id IN (#{sub_ids.join(', ')})")
        else
          tickets = tickets.where(["tickets.category_id = ?", category_id])
        end
    end
    tickets
  end
end
