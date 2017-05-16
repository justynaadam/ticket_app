# frozen_string_literal: true

module ApplicationHelper
  # Returns the full title on a per-page basic

  def full_title(page_title = '')
    base_title = 'Ticket Market'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def sortable(column, title, object)
    direction = column == send('sort_column_' + object.to_s) && sort_direction == 'asc' ? 'desc' : 'asc'
    css_class = column == send('sort_column_' + object.to_s) ? "current #{sort_direction}" : nil
    link_to title, { sort: column, direction: direction }, class: css_class
  end

  def avatar_url(ticket)
    if ticket.picture.present?
      ticket.picture
    else
      gravatar_id = Digest::MD5.hexdigest(ticket.user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png"
   end
  end
end
