class AddLocationToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :location, :string
  end
end
