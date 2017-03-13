class AddTypeOfTicketToSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :type_of_ticket, :string
  end
end
