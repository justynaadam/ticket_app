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

  def sortable(column, title)
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    link_to title, {sort: column, direction: direction}, {class: css_class}
  end
end
